Return-Path: <SRS0=gWTa=IU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21ECDC433C1
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 09:14:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4542761929
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 09:14:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4542761929
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0E324B155;
	Mon, 22 Mar 2021 05:14:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id luOhR-ODeKXv; Mon, 22 Mar 2021 05:14:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 983C24B101;
	Mon, 22 Mar 2021 05:14:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B457C4B0CE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 05:14:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uEeShUSKFldF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Mar 2021 05:14:07 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B72D24B0E1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 05:14:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1616404447;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=zbWUUbFu+6uYq+gRFqXMJokIsMNBL9zEMXnK5XNxQOM=;
 b=N2CorUkygduA5KPlgDG3aO3dvYC/oBKdcRZ7dzlk6QZLYDgCiQXw53ay3y9/dffMDFpdUT
 VSDoiVuxvGUFcNrV7zsTJT3v/JinjEqsa26w0KWmMTD4cL7UYptMfE8EfvPHq9tK56wE+s
 WjSNhPaghAliefMyrnmoG6XpZmKoIHs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-pyK5oxEkM82dRlZ3mwcISw-1; Mon, 22 Mar 2021 05:14:05 -0400
X-MC-Unique: pyK5oxEkM82dRlZ3mwcISw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6BC4A1007474;
 Mon, 22 Mar 2021 09:14:04 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0DA4B60C04;
 Mon, 22 Mar 2021 09:14:02 +0000 (UTC)
Date: Mon, 22 Mar 2021 10:13:54 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH v3] configure: arm/arm64: Add --earlycon
 option to set UART type and address
Message-ID: <20210322091354.jaot4lztjrykb22e@kamzik.brq.redhat.com>
References: <20210319165359.58498-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210319165359.58498-1-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Fri, Mar 19, 2021 at 04:53:59PM +0000, Alexandru Elisei wrote:
> Currently, the UART early address is set indirectly with the --vmm option
> and there are only two possible values: if the VMM is qemu (the default),
> then the UART address is set to 0x09000000; if the VMM is kvmtool, then the
> UART address is set to 0x3f8.
> 
> The upstream kvmtool commit 45b4968e0de1 ("hw/serial: ARM/arm64: Use MMIO
> at higher addresses") changed the UART address to 0x1000000, and
> kvm-unit-tests so far hasn't had mechanism to let the user set a specific
> address, which means that for recent versions of kvmtool the early UART
> won't be available.
> 
> This situation will only become worse as kvm-unit-tests gains support to
> run as an EFI app, as each platform will have their own UART type and
> address.
> 
> To address both issues, a new configure option is added, --earlycon. The
> syntax and semantics are identical to the kernel parameter with the same
> name. For example, for kvmtool, --earlycon=uart,mmio,0x1000000 will set the
> correct UART address. Specifying this option will overwrite the UART
> address set by --vmm.
> 
> At the moment, the UART type and register width parameters are ignored
> since both qemu's and kvmtool's UART emulation use the same offset for the
> TX register and no other registers are used by kvm-unit-tests, but the
> parameters will become relevant once EFI support is added.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
> Besides working with current versions of kvmtool, this will also make early
> console work if the user specifies a custom memory layout [1] (patches are
> old, but I plan to pick them up at some point in the future).
> 
> Changes in v3:
> * Switched to using IFS and read instead of cut.
> * Fixed typo in option description.
> * Added check that $addr is a valid number.
> 
> Changes in v2:
> * kvmtool patches were merged, so I reworked the commit message to point to
>   the corresponding kvmtool commit.
> * Restricted pl011 register size to 32 bits, as per Arm Base System
>   Architecture 1.0 (DEN0094A), and to match Linux.
> * Reworked the way the fields are extracted to make it more precise
>   (without the -s argument, the entire string is echo'ed when no delimiter
>   is found).
> * The changes are not trivial, so I dropped Drew's Reviewed-by.
> 
> [1] https://lore.kernel.org/kvm/1569245722-23375-1-git-send-email-alexandru.elisei@arm.com/
> 
>  configure | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
>

Applied to arm/queue

https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
