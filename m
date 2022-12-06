Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6078C352A1
	for <kvmarm@archiver.kernel.org>; Tue,  6 Dec 2022 14:00:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B43E4B3E3;
	Tue,  6 Dec 2022 09:00:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sfd+yYOC0kpe; Tue,  6 Dec 2022 09:00:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A20F4B3F6;
	Tue,  6 Dec 2022 09:00:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7FBC4B3C1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2022 09:00:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S0qCPHIoJnQt for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Dec 2022 08:59:59 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DE7E4B355
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2022 08:59:59 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E1EE423A;
 Tue,  6 Dec 2022 06:00:04 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com
 [10.1.196.159])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6CE1B3F73D;
 Tue,  6 Dec 2022 05:59:56 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>
Subject: [PATCH v1 00/12] KVM: arm64: Support FEAT_LPA2 at hyp s1 and vm s2
Date: Tue,  6 Dec 2022 13:59:18 +0000
Message-Id: <20221206135930.3277585-1-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

(appologies, I'm resending this series as I managed to send the cover letter to
all but the following patches only to myself on first attempt).

This is my first upstream feature submission so please go easy ;-)

Add support for FEAT_LPA2 to KVM for both hypervisor stage 1 (for the
nvhe/protected modes) and the vm stage 2 translation tables. FEAT_LPA2 enables
52 bit PAs and VAs for 4KB and 16KB granules (note this is already supported for
64KB granules via the FEAT_LPA and FEAT_LVA extensions).

The series does not include support for FEAT_LPA2 in the kernel stage 1. This
support is provided separately by Ard Biesheuvel's series at [1]. Although my
series does not rely on Ard's work and I'm posting the patches based on top of
v6.1-rc6, I have tested with and without Ard's changes and provide the results
below. The testing highlighted some pre-existing bugs in mainline and I have
submitted fixes for these separately at [2], [3], [4]. You can find the tree
without Ard's changes at [5] and a tree with Ard's changes at [6].

The series is broken up into 3 phases; update TLBI routines, support 52-bit
output addresses, and support 52 bit input addresses.

Update TLBI Routines: The update to the range-based TLBI instructions is
technically not needed for the KVM support because KVM only uses the
non-range-based TBLI instructions as far as I can see. But I've done both parts
because I thought it was sensible to do all the updates together - the
range-based stuff will be needed by Ard's patch I think. See commit message for
details.

Support 52-bit Output Addresses: FEAT_LPA2 changes the format of the PTEs. The
HW advertises support for LPA2 independently for stage 1 and stage 2, and
therefore its possible to have it for one and not the other. I've assumed that
there is a valid case for this if stage 1 is not supported but stage 2 is, KVM
could still then use LPA2 at stage 2 to create a 52 bit IPA space (which could
then be consumed by a 64KB page guest kernel with the help of FEAT_LPA). Because
of this independence and the fact that the kvm pgtable library is used for both
stage 1 and stage 2 tables, this means the library now has to remember the
in-use format on a per-page-table basis. To do this, I had to rework some
functions to take a `struct kvm_pgtable *` parameter, and as a result, there is
a noisy patch to add this parameter.

Support 52-bit Input Addresses: The main difficulty here is that at stage 1 for
4KB pages, 52-bit IA requires a extra level of lookup, and that level is called
'-1'. (Although stage 2 can use concatenated pages at the first level, and
therefore still only uses 4 levels, the kvm pgtable library deals with both
stage 1 and stage 2 tables). So there is another noisy patch to convert all
level variables to signed.

This is all tested on the FVP, using a test harness I put together, which does a
host + guest boot test for 180 configurations, built from all the (valid)
combinations of various FVP, host kernel and guest kernel parameters:

 - hw_pa:		[48, lpa, lpa2]
 - hw_va:		[48, 52]
 - kvm_mode:		[vhe, nvhe, protected]
 - host_page_size:	[4KB, 16KB, 64KB]
 - host_pa:		[48, 52]
 - host_va:		[48, 52]
 - host_load_addr:	[low, high]
 - guest_page_size:	[64KB]
 - guest_pa:		[52]
 - guest_va:		[52]
 - guest_load_addr:	[low, high]

I provide the results for the tree at [5] (which doesn't contain Ard's series),
where all tests pass except the 12 cases where a 4KB or 16KB host kernel is
attempting to boot in high memory - these are expected to fail due to the host
kernel not supporting LPA2. When running the tests against the tree at [6]
(which does contain Ard's series plus a few minor fixes), all tests pass.

(I'm omitting guest_page_size, guest_va and guest_pa below since it is always
64KB/52/52).

+-------+-------+-----------+----------------+---------+---------+----------------+-----------------+-------+
| hw_pa | hw_va | kvm_mode  | host_page_size | host_va | host_pa | host_load_addr | guest_load_addr | pass  |
+-------+-------+-----------+----------------+---------+---------+----------------+-----------------+-------+
|  48   |  48   |    vhe    |       4k       |   48    |   48    |      low       |       low       | True  |
|  48   |  48   |    vhe    |       4k       |   52    |   52    |      low       |       low       | True  |
|  48   |  48   |    vhe    |      16k       |   48    |   48    |      low       |       low       | True  |
|  48   |  48   |    vhe    |      16k       |   52    |   52    |      low       |       low       | True  |
|  48   |  48   |    vhe    |      64k       |   48    |   48    |      low       |       low       | True  |
|  48   |  48   |    vhe    |      64k       |   48    |   52    |      low       |       low       | True  |
|  48   |  48   |    vhe    |      64k       |   52    |   48    |      low       |       low       | True  |
|  48   |  48   |    vhe    |      64k       |   52    |   52    |      low       |       low       | True  |
|  48   |  48   |   nvhe    |       4k       |   48    |   48    |      low       |       low       | True  |
|  48   |  48   |   nvhe    |       4k       |   52    |   52    |      low       |       low       | True  |
|  48   |  48   |   nvhe    |      16k       |   48    |   48    |      low       |       low       | True  |
|  48   |  48   |   nvhe    |      16k       |   52    |   52    |      low       |       low       | True  |
|  48   |  48   |   nvhe    |      64k       |   48    |   48    |      low       |       low       | True  |
|  48   |  48   |   nvhe    |      64k       |   48    |   52    |      low       |       low       | True  |
|  48   |  48   |   nvhe    |      64k       |   52    |   48    |      low       |       low       | True  |
|  48   |  48   |   nvhe    |      64k       |   52    |   52    |      low       |       low       | True  |
|  48   |  48   | protected |       4k       |   48    |   48    |      low       |       low       | True  |
|  48   |  48   | protected |       4k       |   52    |   52    |      low       |       low       | True  |
|  48   |  48   | protected |      16k       |   48    |   48    |      low       |       low       | True  |
|  48   |  48   | protected |      16k       |   52    |   52    |      low       |       low       | True  |
|  48   |  48   | protected |      64k       |   48    |   48    |      low       |       low       | True  |
|  48   |  48   | protected |      64k       |   48    |   52    |      low       |       low       | True  |
|  48   |  48   | protected |      64k       |   52    |   48    |      low       |       low       | True  |
|  48   |  48   | protected |      64k       |   52    |   52    |      low       |       low       | True  |
|  48   |  52   |    vhe    |       4k       |   48    |   48    |      low       |       low       | True  |
|  48   |  52   |    vhe    |       4k       |   52    |   52    |      low       |       low       | True  |
|  48   |  52   |    vhe    |      16k       |   48    |   48    |      low       |       low       | True  |
|  48   |  52   |    vhe    |      16k       |   52    |   52    |      low       |       low       | True  |
|  48   |  52   |    vhe    |      64k       |   48    |   48    |      low       |       low       | True  |
|  48   |  52   |    vhe    |      64k       |   48    |   52    |      low       |       low       | True  |
|  48   |  52   |    vhe    |      64k       |   52    |   48    |      low       |       low       | True  |
|  48   |  52   |    vhe    |      64k       |   52    |   52    |      low       |       low       | True  |
|  48   |  52   |   nvhe    |       4k       |   48    |   48    |      low       |       low       | True  |
|  48   |  52   |   nvhe    |       4k       |   52    |   52    |      low       |       low       | True  |
|  48   |  52   |   nvhe    |      16k       |   48    |   48    |      low       |       low       | True  |
|  48   |  52   |   nvhe    |      16k       |   52    |   52    |      low       |       low       | True  |
|  48   |  52   |   nvhe    |      64k       |   48    |   48    |      low       |       low       | True  |
|  48   |  52   |   nvhe    |      64k       |   48    |   52    |      low       |       low       | True  |
|  48   |  52   |   nvhe    |      64k       |   52    |   48    |      low       |       low       | True  |
|  48   |  52   |   nvhe    |      64k       |   52    |   52    |      low       |       low       | True  |
|  48   |  52   | protected |       4k       |   48    |   48    |      low       |       low       | True  |
|  48   |  52   | protected |       4k       |   52    |   52    |      low       |       low       | True  |
|  48   |  52   | protected |      16k       |   48    |   48    |      low       |       low       | True  |
|  48   |  52   | protected |      16k       |   52    |   52    |      low       |       low       | True  |
|  48   |  52   | protected |      64k       |   48    |   48    |      low       |       low       | True  |
|  48   |  52   | protected |      64k       |   48    |   52    |      low       |       low       | True  |
|  48   |  52   | protected |      64k       |   52    |   48    |      low       |       low       | True  |
|  48   |  52   | protected |      64k       |   52    |   52    |      low       |       low       | True  |
|  lpa  |  48   |    vhe    |       4k       |   48    |   48    |      low       |       low       | True  |
|  lpa  |  48   |    vhe    |       4k       |   52    |   52    |      low       |       low       | True  |
|  lpa  |  48   |    vhe    |      16k       |   48    |   48    |      low       |       low       | True  |
|  lpa  |  48   |    vhe    |      16k       |   52    |   52    |      low       |       low       | True  |
|  lpa  |  48   |    vhe    |      64k       |   48    |   48    |      low       |       low       | True  |
|  lpa  |  48   |    vhe    |      64k       |   48    |   52    |      low       |       low       | True  |
|  lpa  |  48   |    vhe    |      64k       |   52    |   48    |      low       |       low       | True  |
|  lpa  |  48   |    vhe    |      64k       |   52    |   52    |      low       |       low       | True  |
|  lpa  |  48   |   nvhe    |       4k       |   48    |   48    |      low       |       low       | True  |
|  lpa  |  48   |   nvhe    |       4k       |   52    |   52    |      low       |       low       | True  |
|  lpa  |  48   |   nvhe    |      16k       |   48    |   48    |      low       |       low       | True  |
|  lpa  |  48   |   nvhe    |      16k       |   52    |   52    |      low       |       low       | True  |
|  lpa  |  48   |   nvhe    |      64k       |   48    |   48    |      low       |       low       | True  |
|  lpa  |  48   |   nvhe    |      64k       |   48    |   52    |      low       |       low       | True  |
|  lpa  |  48   |   nvhe    |      64k       |   52    |   48    |      low       |       low       | True  |
|  lpa  |  48   |   nvhe    |      64k       |   52    |   52    |      low       |       low       | True  |
|  lpa  |  48   | protected |       4k       |   48    |   48    |      low       |       low       | True  |
|  lpa  |  48   | protected |       4k       |   52    |   52    |      low       |       low       | True  |
|  lpa  |  48   | protected |      16k       |   48    |   48    |      low       |       low       | True  |
|  lpa  |  48   | protected |      16k       |   52    |   52    |      low       |       low       | True  |
|  lpa  |  48   | protected |      64k       |   48    |   48    |      low       |       low       | True  |
|  lpa  |  48   | protected |      64k       |   48    |   52    |      low       |       low       | True  |
|  lpa  |  48   | protected |      64k       |   52    |   48    |      low       |       low       | True  |
|  lpa  |  48   | protected |      64k       |   52    |   52    |      low       |       low       | True  |
|  lpa  |  52   |    vhe    |       4k       |   48    |   48    |      low       |       low       | True  |
|  lpa  |  52   |    vhe    |       4k       |   52    |   52    |      low       |       low       | True  |
|  lpa  |  52   |    vhe    |      16k       |   48    |   48    |      low       |       low       | True  |
|  lpa  |  52   |    vhe    |      16k       |   52    |   52    |      low       |       low       | True  |
|  lpa  |  52   |    vhe    |      64k       |   48    |   48    |      low       |       low       | True  |
|  lpa  |  52   |    vhe    |      64k       |   48    |   48    |      low       |      high       | True  |
|  lpa  |  52   |    vhe    |      64k       |   48    |   52    |      low       |       low       | True  |
|  lpa  |  52   |    vhe    |      64k       |   48    |   52    |      low       |      high       | True  |
|  lpa  |  52   |    vhe    |      64k       |   52    |   48    |      low       |       low       | True  |
|  lpa  |  52   |    vhe    |      64k       |   52    |   48    |      low       |      high       | True  |
|  lpa  |  52   |    vhe    |      64k       |   52    |   52    |      low       |       low       | True  |
|  lpa  |  52   |    vhe    |      64k       |   52    |   52    |      low       |      high       | True  |
|  lpa  |  52   |    vhe    |      64k       |   52    |   52    |      high      |       low       | True  |
|  lpa  |  52   |    vhe    |      64k       |   52    |   52    |      high      |      high       | True  |
|  lpa  |  52   |   nvhe    |       4k       |   48    |   48    |      low       |       low       | True  |
|  lpa  |  52   |   nvhe    |       4k       |   52    |   52    |      low       |       low       | True  |
|  lpa  |  52   |   nvhe    |      16k       |   48    |   48    |      low       |       low       | True  |
|  lpa  |  52   |   nvhe    |      16k       |   52    |   52    |      low       |       low       | True  |
|  lpa  |  52   |   nvhe    |      64k       |   48    |   48    |      low       |       low       | True  |
|  lpa  |  52   |   nvhe    |      64k       |   48    |   48    |      low       |      high       | True  |
|  lpa  |  52   |   nvhe    |      64k       |   48    |   52    |      low       |       low       | True  |
|  lpa  |  52   |   nvhe    |      64k       |   48    |   52    |      low       |      high       | True  |
|  lpa  |  52   |   nvhe    |      64k       |   52    |   48    |      low       |       low       | True  |
|  lpa  |  52   |   nvhe    |      64k       |   52    |   48    |      low       |      high       | True  |
|  lpa  |  52   |   nvhe    |      64k       |   52    |   52    |      low       |       low       | True  |
|  lpa  |  52   |   nvhe    |      64k       |   52    |   52    |      low       |      high       | True  |
|  lpa  |  52   |   nvhe    |      64k       |   52    |   52    |      high      |       low       | True  |
|  lpa  |  52   |   nvhe    |      64k       |   52    |   52    |      high      |      high       | True  |
|  lpa  |  52   | protected |       4k       |   48    |   48    |      low       |       low       | True  |
|  lpa  |  52   | protected |       4k       |   52    |   52    |      low       |       low       | True  |
|  lpa  |  52   | protected |      16k       |   48    |   48    |      low       |       low       | True  |
|  lpa  |  52   | protected |      16k       |   52    |   52    |      low       |       low       | True  |
|  lpa  |  52   | protected |      64k       |   48    |   48    |      low       |       low       | True  |
|  lpa  |  52   | protected |      64k       |   48    |   48    |      low       |      high       | True  |
|  lpa  |  52   | protected |      64k       |   48    |   52    |      low       |       low       | True  |
|  lpa  |  52   | protected |      64k       |   48    |   52    |      low       |      high       | True  |
|  lpa  |  52   | protected |      64k       |   52    |   48    |      low       |       low       | True  |
|  lpa  |  52   | protected |      64k       |   52    |   48    |      low       |      high       | True  |
|  lpa  |  52   | protected |      64k       |   52    |   52    |      low       |       low       | True  |
|  lpa  |  52   | protected |      64k       |   52    |   52    |      low       |      high       | True  |
|  lpa  |  52   | protected |      64k       |   52    |   52    |      high      |       low       | True  |
|  lpa  |  52   | protected |      64k       |   52    |   52    |      high      |      high       | True  |
| lpa2  |  52   |    vhe    |       4k       |   48    |   48    |      low       |       low       | True  |
| lpa2  |  52   |    vhe    |       4k       |   48    |   48    |      low       |      high       | True  |
| lpa2  |  52   |    vhe    |       4k       |   52    |   52    |      low       |       low       | True  |
| lpa2  |  52   |    vhe    |       4k       |   52    |   52    |      low       |      high       | True  |
| lpa2  |  52   |    vhe    |       4k       |   52    |   52    |      high      |       low       | False |
| lpa2  |  52   |    vhe    |       4k       |   52    |   52    |      high      |      high       | False |
| lpa2  |  52   |    vhe    |      16k       |   48    |   48    |      low       |       low       | True  |
| lpa2  |  52   |    vhe    |      16k       |   48    |   48    |      low       |      high       | True  |
| lpa2  |  52   |    vhe    |      16k       |   52    |   52    |      low       |       low       | True  |
| lpa2  |  52   |    vhe    |      16k       |   52    |   52    |      low       |      high       | True  |
| lpa2  |  52   |    vhe    |      16k       |   52    |   52    |      high      |       low       | False |
| lpa2  |  52   |    vhe    |      16k       |   52    |   52    |      high      |      high       | False |
| lpa2  |  52   |    vhe    |      64k       |   48    |   48    |      low       |       low       | True  |
| lpa2  |  52   |    vhe    |      64k       |   48    |   48    |      low       |      high       | True  |
| lpa2  |  52   |    vhe    |      64k       |   48    |   52    |      low       |       low       | True  |
| lpa2  |  52   |    vhe    |      64k       |   48    |   52    |      low       |      high       | True  |
| lpa2  |  52   |    vhe    |      64k       |   52    |   48    |      low       |       low       | True  |
| lpa2  |  52   |    vhe    |      64k       |   52    |   48    |      low       |      high       | True  |
| lpa2  |  52   |    vhe    |      64k       |   52    |   52    |      low       |       low       | True  |
| lpa2  |  52   |    vhe    |      64k       |   52    |   52    |      low       |      high       | True  |
| lpa2  |  52   |    vhe    |      64k       |   52    |   52    |      high      |       low       | True  |
| lpa2  |  52   |    vhe    |      64k       |   52    |   52    |      high      |      high       | True  |
| lpa2  |  52   |   nvhe    |       4k       |   48    |   48    |      low       |       low       | True  |
| lpa2  |  52   |   nvhe    |       4k       |   48    |   48    |      low       |      high       | True  |
| lpa2  |  52   |   nvhe    |       4k       |   52    |   52    |      low       |       low       | True  |
| lpa2  |  52   |   nvhe    |       4k       |   52    |   52    |      low       |      high       | True  |
| lpa2  |  52   |   nvhe    |       4k       |   52    |   52    |      high      |       low       | False |
| lpa2  |  52   |   nvhe    |       4k       |   52    |   52    |      high      |      high       | False |
| lpa2  |  52   |   nvhe    |      16k       |   48    |   48    |      low       |       low       | True  |
| lpa2  |  52   |   nvhe    |      16k       |   48    |   48    |      low       |      high       | True  |
| lpa2  |  52   |   nvhe    |      16k       |   52    |   52    |      low       |       low       | True  |
| lpa2  |  52   |   nvhe    |      16k       |   52    |   52    |      low       |      high       | True  |
| lpa2  |  52   |   nvhe    |      16k       |   52    |   52    |      high      |       low       | False |
| lpa2  |  52   |   nvhe    |      16k       |   52    |   52    |      high      |      high       | False |
| lpa2  |  52   |   nvhe    |      64k       |   48    |   48    |      low       |       low       | True  |
| lpa2  |  52   |   nvhe    |      64k       |   48    |   48    |      low       |      high       | True  |
| lpa2  |  52   |   nvhe    |      64k       |   48    |   52    |      low       |       low       | True  |
| lpa2  |  52   |   nvhe    |      64k       |   48    |   52    |      low       |      high       | True  |
| lpa2  |  52   |   nvhe    |      64k       |   52    |   48    |      low       |       low       | True  |
| lpa2  |  52   |   nvhe    |      64k       |   52    |   48    |      low       |      high       | True  |
| lpa2  |  52   |   nvhe    |      64k       |   52    |   52    |      low       |       low       | True  |
| lpa2  |  52   |   nvhe    |      64k       |   52    |   52    |      low       |      high       | True  |
| lpa2  |  52   |   nvhe    |      64k       |   52    |   52    |      high      |       low       | True  |
| lpa2  |  52   |   nvhe    |      64k       |   52    |   52    |      high      |      high       | True  |
| lpa2  |  52   | protected |       4k       |   48    |   48    |      low       |       low       | True  |
| lpa2  |  52   | protected |       4k       |   48    |   48    |      low       |      high       | True  |
| lpa2  |  52   | protected |       4k       |   52    |   52    |      low       |       low       | True  |
| lpa2  |  52   | protected |       4k       |   52    |   52    |      low       |      high       | True  |
| lpa2  |  52   | protected |       4k       |   52    |   52    |      high      |       low       | False |
| lpa2  |  52   | protected |       4k       |   52    |   52    |      high      |      high       | False |
| lpa2  |  52   | protected |      16k       |   48    |   48    |      low       |       low       | True  |
| lpa2  |  52   | protected |      16k       |   48    |   48    |      low       |      high       | True  |
| lpa2  |  52   | protected |      16k       |   52    |   52    |      low       |       low       | True  |
| lpa2  |  52   | protected |      16k       |   52    |   52    |      low       |      high       | True  |
| lpa2  |  52   | protected |      16k       |   52    |   52    |      high      |       low       | False |
| lpa2  |  52   | protected |      16k       |   52    |   52    |      high      |      high       | False |
| lpa2  |  52   | protected |      64k       |   48    |   48    |      low       |       low       | True  |
| lpa2  |  52   | protected |      64k       |   48    |   48    |      low       |      high       | True  |
| lpa2  |  52   | protected |      64k       |   48    |   52    |      low       |       low       | True  |
| lpa2  |  52   | protected |      64k       |   48    |   52    |      low       |      high       | True  |
| lpa2  |  52   | protected |      64k       |   52    |   48    |      low       |       low       | True  |
| lpa2  |  52   | protected |      64k       |   52    |   48    |      low       |      high       | True  |
| lpa2  |  52   | protected |      64k       |   52    |   52    |      low       |       low       | True  |
| lpa2  |  52   | protected |      64k       |   52    |   52    |      low       |      high       | True  |
| lpa2  |  52   | protected |      64k       |   52    |   52    |      high      |       low       | True  |
| lpa2  |  52   | protected |      64k       |   52    |   52    |      high      |      high       | True  |
+-------+-------+-----------+----------------+---------+---------+----------------+-----------------+-------+

[1] https://lore.kernel.org/linux-arm-kernel/20221124123932.2648991-1-ardb@kernel.org
[2] https://lore.kernel.org/kvmarm/20221027120945.29679-1-ryan.roberts@arm.com
[3] https://lore.kernel.org/kvmarm/20221103150507.32948-1-ryan.roberts@arm.com
[4] https://lore.kernel.org/kvmarm/20221205114031.3972780-1-ryan.roberts@arm.com
[5] https://gitlab.arm.com/linux-arm/linux-rr/-/tree/features/lpa2/kvm_lkml-v1
[6] https://gitlab.arm.com/linux-arm/linux-rr/-/tree/features/lpa2/ardb_arm64-4k-lpa2_plus_kvm_2022-12-01

Thanks,
Ryan


Anshuman Khandual (1):
  arm64/mm: Add FEAT_LPA2 specific ID_AA64MMFR0.TGRAN[2]

Ryan Roberts (11):
  arm64/mm: Update tlb invalidation routines for FEAT_LPA2
  KVM: arm64: Add new (V)TCR_EL2 field definitions for FEAT_LPA2
  KVM: arm64: Plumbing to enable multiple pgtable formats
  KVM: arm64: Maintain page-table format info in struct kvm_pgtable
  KVM: arm64: Use LPA2 page-tables for stage2 if HW supports it
  KVM: arm64: Use LPA2 page-tables for hyp stage1 if HW supports it
  KVM: arm64: Insert PS field at TCR_EL2 assembly time
  KVM: arm64: Convert translation level parameter to s8
  KVM: arm64: Rework logic to en/decode VTCR_EL2.{SL0, SL2} fields
  KVM: arm64: Support upto 5 levels of translation in kvm_pgtable
  KVM: arm64: Allow guests with >48-bit IPA size on FEAT_LPA2 systems

 arch/arm64/include/asm/kvm_arm.h        |  79 +++---
 arch/arm64/include/asm/kvm_emulate.h    |  14 +-
 arch/arm64/include/asm/kvm_pgtable.h    | 131 +++++++--
 arch/arm64/include/asm/kvm_pkvm.h       |   5 +-
 arch/arm64/include/asm/pgtable-prot.h   |   6 +
 arch/arm64/include/asm/stage2_pgtable.h |  13 +-
 arch/arm64/include/asm/sysreg.h         |   5 +
 arch/arm64/include/asm/tlb.h            |  15 +-
 arch/arm64/include/asm/tlbflush.h       |  83 ++++--
 arch/arm64/kvm/arm.c                    |   5 +
 arch/arm64/kvm/hyp/nvhe/hyp-init.S      |   4 -
 arch/arm64/kvm/hyp/nvhe/mem_protect.c   |  21 +-
 arch/arm64/kvm/hyp/nvhe/setup.c         |  28 +-
 arch/arm64/kvm/hyp/pgtable.c            | 354 +++++++++++++++---------
 arch/arm64/kvm/mmu.c                    |  15 +-
 arch/arm64/kvm/reset.c                  |  11 +-
 16 files changed, 525 insertions(+), 264 deletions(-)

--
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
