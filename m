Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D32DFC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 13:33:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BE1149E44;
	Tue, 15 Mar 2022 09:33:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WrruyEeO3NNC; Tue, 15 Mar 2022 09:33:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA26649ED8;
	Tue, 15 Mar 2022 09:33:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DC2449E44
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 09:33:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wk8RIVtbjQEC for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 09:33:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFAE749E43
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 09:33:33 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7124D1474;
 Tue, 15 Mar 2022 06:33:33 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 300303F66F;
 Tue, 15 Mar 2022 06:33:32 -0700 (PDT)
Date: Tue, 15 Mar 2022 13:33:57 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com, thuth@redhat.com, drjones@redhat.com,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Subject: [kvm-unit-tests] Adding the QCBOR library to kvm-unit-tests
Message-ID: <YjCVxT1yo0hi6Vdc@monolith.localdoman>
MIME-Version: 1.0
Content-Disposition: inline
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

Hi,

Arm is planning to upstream tests that are being developed as part of the
Confidential Compute Architecture [1]. Some of the tests target the
attestation part of creating and managing a confidential compute VM, which
requires the manipulation of messages in the Concise Binary Object
Representation (CBOR) format [2].

I would like to ask if it would be acceptable from a license perspective to
include the QCBOR library [3] into kvm-unit-tests, which will be used for
encoding and decoding of CBOR messages.

The library is licensed under the 3-Clause BSD license, which is compatible
with GPLv2 [4]. Some of the files that were created inside Qualcomm before
the library was open-sourced have a slightly modified 3-Clause BSD license,
where a NON-INFRINGMENT clause is added to the disclaimer:

"THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE **AND NON-INFRINGEMENT**
ARE DISCLAIMED" (emphasis by me on the added clause).

The files in question include the core files that implement the
encode/decode functionality, and thus would have to be included in
kvm-unit-tests. I believe that the above modification does not affect the
compatibility with GPLv2.

I would also like to mention that the QCBOR library is also used in Trusted
Firmware-M [5], which is licensed under BSD 3-Clause.

[1] https://www.arm.com/architecture/security-features/arm-confidential-compute-architecture
[2] https://datatracker.ietf.org/doc/html/rfc8949
[3] https://github.com/laurencelundblade/QCBOR
[4] https://www.gnu.org/licenses/license-list.html#GPLCompatibleLicenses
[5] https://git.trustedfirmware.org/TF-M/trusted-firmware-m.git/tree/lib/ext/qcbor

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
