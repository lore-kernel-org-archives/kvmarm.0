Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1413C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 15:48:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2819149EFC;
	Tue, 15 Mar 2022 11:48:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DrNATLS9ioZj; Tue, 15 Mar 2022 11:48:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E14A549EFE;
	Tue, 15 Mar 2022 11:48:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70DB149E0E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 11:48:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id APfpBopwUtDb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 11:48:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D359E4076A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 11:48:06 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4DF621474;
 Tue, 15 Mar 2022 08:48:06 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0C6B43F766;
 Tue, 15 Mar 2022 08:48:04 -0700 (PDT)
Date: Tue, 15 Mar 2022 15:48:30 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests] Adding the QCBOR library to kvm-unit-tests
Message-ID: <YjC1TsFlZeTAeyYD@monolith.localdoman>
References: <YjCVxT1yo0hi6Vdc@monolith.localdoman>
 <b1d5e4b7-c07c-0e34-ef6d-58aab19a41b2@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b1d5e4b7-c07c-0e34-ef6d-58aab19a41b2@redhat.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Tue, Mar 15, 2022 at 03:21:39PM +0100, Thomas Huth wrote:
> On 15/03/2022 14.33, Alexandru Elisei wrote:
> > Hi,
> > 
> > Arm is planning to upstream tests that are being developed as part of the
> > Confidential Compute Architecture [1]. Some of the tests target the
> > attestation part of creating and managing a confidential compute VM, which
> > requires the manipulation of messages in the Concise Binary Object
> > Representation (CBOR) format [2].
> > 
> > I would like to ask if it would be acceptable from a license perspective to
> > include the QCBOR library [3] into kvm-unit-tests, which will be used for
> > encoding and decoding of CBOR messages.
> > 
> > The library is licensed under the 3-Clause BSD license, which is compatible
> > with GPLv2 [4]. Some of the files that were created inside Qualcomm before
> > the library was open-sourced have a slightly modified 3-Clause BSD license,
> > where a NON-INFRINGMENT clause is added to the disclaimer:
> > 
> > "THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
> > WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
> > MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE **AND NON-INFRINGEMENT**
> > ARE DISCLAIMED" (emphasis by me on the added clause).
> > 
> > The files in question include the core files that implement the
> > encode/decode functionality, and thus would have to be included in
> > kvm-unit-tests. I believe that the above modification does not affect the
> > compatibility with GPLv2.
> 
> IANAL, but I think it should be ok to add those files to the kvm-unit-tests.
> With regards to the "non-infringement" extension, it seems to be the one
> mentioned here: https://enterprise.dejacode.com/licenses/public/bsd-x11/ ...
> and on the "license condition" tab they mention that it is compatible with
> the GPL. On gnu.org, they list e.g. the
> https://www.gnu.org/licenses/license-list.html#X11License which also
> contains a "non-infringement" statement, so that should really be
> compatible.

Thanks you for the links, I wasn't aware of them. They further confirm that
QCBOR is indeed compatible with GPLv2.

Thanks,
Alex

> 
>  Thomas
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
