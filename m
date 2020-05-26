Return-Path: <SRS0=x9SY=7I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64C9FC433E4
	for <kvmarm@archiver.kernel.org>; Tue, 26 May 2020 05:59:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1583E2071A
	for <kvmarm@archiver.kernel.org>; Tue, 26 May 2020 05:59:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=ozlabs.org header.i=@ozlabs.org header.b="khGxIciP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1583E2071A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9C184B255;
	Tue, 26 May 2020 01:59:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ozlabs.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NwLbHGkB-zf1; Tue, 26 May 2020 01:59:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BE454B259;
	Tue, 26 May 2020 01:59:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FBA24B241
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2020 01:59:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pULj2bimas7f for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 May 2020 01:59:34 -0400 (EDT)
Received: from ozlabs.org (ozlabs.org [203.11.71.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C1324B248
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2020 01:59:33 -0400 (EDT)
Received: by ozlabs.org (Postfix, from userid 1003)
 id 49WNZn04xgz9sSs; Tue, 26 May 2020 15:59:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
 t=1590472769; bh=4zTMjLxiP7At/YtrE7MFZ9lR12F6gL3vS4op93NKqcw=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=khGxIciPhO0Sfk2SnU/0Ae673wU3qJd++HDVCdDXw0crK8Ypm2/n9l62eVF831yOi
 qSlxMK1kVwrGk5Ie4AuHOGiyMVvCJOwjYXSbzPDmsHvR8Rc6dTcCW4fUqTmnv2FFC3
 IC6DoGsAZ7Lz1lXXrlNfXZL/2bFCAo2dtE/thks2LK2v0to3aW5buJZfJX1GsIWfGN
 AgMpuG9PWO3XTyuFrjqeVqtJHgB3BOMn3n4bxBUe7RXQfa23LEupF1Ywt0g5DVnF/1
 IVVxPvpB947tg6+DMLQ0rMbIi1mYImwuRTcOzmoU9yY9DUZ2d3cWMG3nlOTWEdkC0S
 nbtLhygWbPVew==
Date: Tue, 26 May 2020 15:59:24 +1000
From: Paul Mackerras <paulus@ozlabs.org>
To: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: Re: [PATCH v4 5/7] KVM: PPC: clean up redundant kvm_run parameters
 in assembly
Message-ID: <20200526055924.GD282305@thinks.paulus.ozlabs.org>
References: <20200427043514.16144-1-tianjia.zhang@linux.alibaba.com>
 <20200427043514.16144-6-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200427043514.16144-6-tianjia.zhang@linux.alibaba.com>
Cc: wanpengli@tencent.com, kvm@vger.kernel.org, david@redhat.com,
 benh@kernel.crashing.org, heiko.carstens@de.ibm.com,
 linux-mips@vger.kernel.org, hpa@zytor.com, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, frankja@linux.ibm.com, chenhuacai@gmail.com,
 maz@kernel.org, joro@8bytes.org, x86@kernel.org, borntraeger@de.ibm.com,
 mingo@redhat.com, thuth@redhat.com, gor@linux.ibm.com, kvm-ppc@vger.kernel.org,
 bp@alien8.de, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org,
 jmattson@google.com, tsbogend@alpha.franken.de, cohuck@redhat.com,
 sean.j.christopherson@intel.com, linux-kernel@vger.kernel.org,
 mpe@ellerman.id.au, pbonzini@redhat.com, vkuznets@redhat.com,
 linuxppc-dev@lists.ozlabs.org
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

On Mon, Apr 27, 2020 at 12:35:12PM +0800, Tianjia Zhang wrote:
> In the current kvm version, 'kvm_run' has been included in the 'kvm_vcpu'
> structure. For historical reasons, many kvm-related function parameters
> retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time. This
> patch does a unified cleanup of these remaining redundant parameters.

Some of these changes don't look completely correct to me, see below.
If you're expecting these patches to go through my tree, I can fix up
the patch and commit it (with you as author), noting the changes I
made in the commit message.  Do you want me to do that?

> diff --git a/arch/powerpc/kvm/book3s_interrupts.S b/arch/powerpc/kvm/book3s_interrupts.S
> index f7ad99d972ce..0eff749d8027 100644
> --- a/arch/powerpc/kvm/book3s_interrupts.S
> +++ b/arch/powerpc/kvm/book3s_interrupts.S
> @@ -55,8 +55,7 @@
>   ****************************************************************************/
>  
>  /* Registers:
> - *  r3: kvm_run pointer
> - *  r4: vcpu pointer
> + *  r3: vcpu pointer
>   */
>  _GLOBAL(__kvmppc_vcpu_run)
>  
> @@ -68,8 +67,8 @@ kvm_start_entry:
>  	/* Save host state to the stack */
>  	PPC_STLU r1, -SWITCH_FRAME_SIZE(r1)
>  
> -	/* Save r3 (kvm_run) and r4 (vcpu) */
> -	SAVE_2GPRS(3, r1)
> +	/* Save r3 (vcpu) */
> +	SAVE_GPR(3, r1)
>  
>  	/* Save non-volatile registers (r14 - r31) */
>  	SAVE_NVGPRS(r1)
> @@ -82,11 +81,11 @@ kvm_start_entry:
>  	PPC_STL	r0, _LINK(r1)
>  
>  	/* Load non-volatile guest state from the vcpu */
> -	VCPU_LOAD_NVGPRS(r4)
> +	VCPU_LOAD_NVGPRS(r3)
>  
>  kvm_start_lightweight:
>  	/* Copy registers into shadow vcpu so we can access them in real mode */
> -	mr	r3, r4
> +	mr	r4, r3

This mr doesn't seem necessary.

>  	bl	FUNC(kvmppc_copy_to_svcpu)
>  	nop
>  	REST_GPR(4, r1)

This should be loading r4 from GPR3(r1), not GPR4(r1) - which is what
REST_GPR(4, r1) will do.

Then, in the file but not in the patch context, there is this line:

	PPC_LL	r3, GPR4(r1)		/* vcpu pointer */

where once again GPR4 needs to be GPR3.

> @@ -191,10 +190,10 @@ after_sprg3_load:
>  	PPC_STL	r31, VCPU_GPR(R31)(r7)
>  
>  	/* Pass the exit number as 3rd argument to kvmppc_handle_exit */

The comment should be modified to say "2nd" instead of "3rd",
otherwise it is confusing.

The rest of the patch looks OK.

Paul.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
