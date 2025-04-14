Received: from smtp-fw-9106.amazon.com (smtp-fw-9106.amazon.com [207.171.188.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484ED2980C0
	for <kvmarm@lists.linux.dev>; Mon, 14 Apr 2025 11:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744629342; cv=none; b=JvUrNzuL8OsVRuX5uaVrZ5vRoBpTxF7OIuGCUGF4S3N7w4QpUX/IxC5L+zNUnr/mZhJ30o6vEatw/wAmRiGGOh4OGdV92v5zudmCyElOYL54XlRIsIW8baTWVEADKKE/DIykKIIwilRhnlM+ab/RhSsC71flY6zrMcYqv4Uc8wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744629342; c=relaxed/simple;
	bh=SmifMpnLnySNZXsoTuOxoreD2ECShgsVY+a10tcxRLw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VdN13tn5xR8EZ8UkqAV1u7Vsdgl5P7cE/SNy6KcJz5fmuX8OUWgttlEwOiCdowtA2bkK/3+w/YtWFVAfA/k+VOPMfBVxkWDdf9aMkg25uvFgvWGQLhSJ3DH5vy/LqrxL3vNSKSqsqJ4Ne7Mo9VSjgGYIWYh5oLI2+P9VbuuSsuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=nMQXe5f5; arc=none smtp.client-ip=207.171.188.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="nMQXe5f5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1744629340; x=1776165340;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FvxpSXO+bFgB1St+7rEJp93C352vyZIr+mzbHjB7ijA=;
  b=nMQXe5f5KdOVJccWtI01anpTiJcwadkky3L+E8SF9MYFp1Kyj3MCV/IF
   j4vgC9k3GqIv/gG3JLmCcNmGS14N8zcTr5lxFBrvuvphlp5oTEKXdk0hl
   rL73M5Uxq+XrlTvWtRYyg6/telgLIb8jdfKbCwIA39qmHyR4jKk3AOMIh
   U=;
X-IronPort-AV: E=Sophos;i="6.15,212,1739836800"; 
   d="scan'208";a="815825200"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9106.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 11:15:34 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.43.254:44527]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.12.56:2525] with esmtp (Farcaster)
 id fea6780a-9d42-46ff-ab79-6f921b6f0769; Mon, 14 Apr 2025 11:15:32 +0000 (UTC)
X-Farcaster-Flow-ID: fea6780a-9d42-46ff-ab79-6f921b6f0769
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 14 Apr 2025 11:15:32 +0000
Received: from u94b036d6357a55.ant.amazon.com.com (10.106.82.24) by
 EX19D018EUA002.ant.amazon.com (10.252.50.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 14 Apr 2025 11:15:26 +0000
From: Ilias Stamatis <ilstam@amazon.com>
To: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<maz@kernel.org>, <oliver.upton@linux.dev>
CC: <joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<eric.auger@redhat.com>, <andre.przywara@arm.com>, <will@kernel.org>,
	<dwmw@amazon.co.uk>, <ilstam@amazon.com>, <jgrall@amazon.co.uk>,
	<ugurus@amazon.co.uk>, <nh-open-source@amazon.com>
Subject: [RFC] ARM vGIC-ITS tables serialization when running protected VMs
Date: Mon, 14 Apr 2025 12:12:43 +0100
Message-ID: <20250414111244.153528-1-ilstam@amazon.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D041UWB004.ant.amazon.com (10.13.139.143) To
 EX19D018EUA002.ant.amazon.com (10.252.50.146)

# The problem

KVM's ARM Virtual Interrupt Translation Service (ITS) interface supports the
KVM_DEV_ARM_ITS_SAVE_TABLES and KVM_DEV_ARM_ITS_RESTORE_TABLES operations.
These operations save and restore a set of tables (Device Tables, Interrupt
Translation Tables, Collection Table) to and from guest memory.

This can be a problem when running a protected VM on top of pKVM or another
lowvisor since the host kernel (running at EL1) cannot access guest memory.

# Page declassification and why ITTs are special

The Collection and Device tables are page aligned and their sizes must be a
multiple of page size. If the lowvisor knows where these tables live, it is
possible to "declassify" the corresponding pages and configure the MMU such as
that the EL1 host can write to guest memory directly.

The ITTs (Interrupt Translation Tables) are different. They are NOT page
aligned, they are 256 byte aligned and their size is variable. That means that
the lowvisor can't declassify pages containing ITTs and configure the MMU
giving the host direct access as above since those pages may contain unrelated
data.

If the lowvisor knows where the ITTs live in guest memory it could instead
perform the guest memory accesses on behalf of the host. I.e. the EL1 host
would attempt to save the ITTs to guest memory like it does today, that would
generate a data abort, and then the EL2 lowvisor could perform the copy after
validating that the faulty address belongs to an ITT in guest memory.

One issue with the above is that the ITS save/restore happens at hypervisor
live update which is a time sensitive operation and the extra traps (one per
interrupt mapping?) can introduce significant additional overhead there.

Another issue is that it's actually hard for the lowvisor to know where these
tables live without trusting the EL1 host which virtualizes the ITS. It is
especially hard knowing the locations of the ITTs (compared to
Collection/Device tables) because that probably means having to parse the ITS
command queue from EL2 which is complex and undesirable.

# An alternative: Serializing ITTs into a userspace buffer

Rather than writing the ITTs to guest memory, the EL1 host can serialize them
into a buffer provided by userspace.

The struct kvm_device_attr passed to KVM_DEV_ARM_ITS_{SAVE,RESTORE}_TABLES has
a currently unused 'addr' field that can be used for the buffer address. The
upper 32-bits of 'attr' from the struct could be used for the buffer size (even
though that feels hacky). Also a flag in the 'flags' field can be used to
determine whether the userspace buffer must be used or not.

I'm attaching a not-so-pretty RFC patch that does just this. The format of the
blob stored in the buffer is the following. There is a 64-bit ITT start marker
which embeds the device ID owning the ITT. The start marker is followed by
64-bit ITEs stored using the existing ITS Table ABI REV0 with the 'next' field
being replaced by an 'event_id' field which stores the event ID rather than an
offset. An end marker indicates the end of the ITT and is followed by the start
marker for the ITT of the next device.

Note that I haven't actually documented this new ABI in the patch yet, because
it's unlikely to stay as it is. There are many different ways to achieve the
same result.

Also note that this patch treats the ITTs specially for the reasons mentioned
in the previous section (harder to declassify), but there could be flags for
choosing between storing all tables or just the ITTs in the userspace buffer.

Finally, the patch is based on an older kernel tree at the moment but from a
quick look it won't be too difficult to rebase on top of 6.15. However, I
wanted some initial feedback to see whether this approach is something that
maintainers would even consider before rebasing, adding tests and making this
as robust as possible.

# How can userspace calculate the size of the buffer?

This is another big problem. Today the guest is responsible for allocating
memory for the ITTs (and other tables) before passing it to the (v)GIC.
However, if userspace is to provide the host kernel with a buffer it has to
know how much memory to allocate for it.

Userspace should probably account for the worst case where ITTs are fully
populated. The theoritical maximum depends on the number of Device ID bits and
Event ID bits that the ITS advertises. Today these values are fixed in KVM's
vITS and set to 16 bits each. Therefore the theoritical maximum is a very large
number (2^16 * 2^16 * 8 bytes per ITT entry = 32GiB per vITS) which is
unrealistic.

However, it should be possible to make the Device ID and Event ID bits
configurable by userspace. That way by using smaller numbers there, the
theoritical maximum for the ITTs can be reduced to more realistic sizes.

# Please suggest something better

I'm fully aware that this is not a great patch and feels hacky and potentially
non-robust. However, I'm struggling to come up with anything better and this
RFC is meant to start a discussion around this problem. Is storing the ITS
tables in host memory something that makes sense or is there a better/simpler
approach that would work for Confidential Computing?

Thanks

Ilias Stamatis (1):
  KVM: arm64: vgic-its: Add flag for saving ITTs in userspace buffer

 arch/arm64/include/uapi/asm/kvm.h |   5 +
 arch/arm64/kvm/vgic/vgic-its.c    | 213 +++++++++++++++++++++++++++++-
 arch/arm64/kvm/vgic/vgic.h        |   4 +
 include/kvm/arm_vgic.h            |  11 ++
 4 files changed, 227 insertions(+), 6 deletions(-)

-- 
2.47.1

