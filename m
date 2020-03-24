Return-Path: <SRS0=kG2x=5J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80C22C10DCE
	for <kvmarm@archiver.kernel.org>; Tue, 24 Mar 2020 01:19:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F0CBB2070A
	for <kvmarm@archiver.kernel.org>; Tue, 24 Mar 2020 01:19:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=ozlabs.org header.i=@ozlabs.org header.b="mauSiS7o"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F0CBB2070A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5490F4B0AC;
	Mon, 23 Mar 2020 21:19:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ozlabs.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W2t6JJdCWCCk; Mon, 23 Mar 2020 21:19:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 383DA4B097;
	Mon, 23 Mar 2020 21:19:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C78554B08E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 21:19:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0yvpbxaGgmP0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Mar 2020 21:19:02 -0400 (EDT)
Received: from ozlabs.org (bilbo.ozlabs.org [203.11.71.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B4614A4FC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 21:19:02 -0400 (EDT)
Received: by ozlabs.org (Postfix, from userid 1003)
 id 48mYL92hc1z9sSL; Tue, 24 Mar 2020 12:18:57 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
 t=1585012737; bh=fWyvQjgmoVE45UQb8yBNTXiPed69yDbrhs5hdq0egsU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=mauSiS7oX6+4B1f4axm7Ayy0Hc0K4hbGipg06Vcls1bvNoep91a4i3dcGDcZKVpTJ
 xQC/JEjuilfLaSd1tD8NcDipXJjAbo7uhRcrYKD9LE8of4vea9QfKCKUAAkkdF/Uz7
 Dm7c/6XLcWYDVEm/PsidIOCTDafYwb4ENnFnDtX0zf2M52X8TbyUepK8RCjm3hj5Lu
 u8f6BSKtFagIKKzXfDcwdZegidVRR/Rw5iEGwGP+42XDZ08MSFz0spgTcZk9vvMJUq
 WBwqbuf0TPBzwB0coc1LPf1cCR+z4iTVCk1La6TvnzTrCQ1Bv8TD6+qUuXAoP37xGr
 j9GwIDroxtTsA==
Date: Tue, 24 Mar 2020 12:18:54 +1100
From: Paul Mackerras <paulus@ozlabs.org>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v3 1/9] KVM: Pass kvm_init()'s opaque param to additional
 arch funcs
Message-ID: <20200324011854.GC5604@blackberry>
References: <20200321202603.19355-1-sean.j.christopherson@intel.com>
 <20200321202603.19355-2-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200321202603.19355-2-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Cc: Wanpeng Li <wanpengli@tencent.com>, Janosch Frank <frankja@linux.ibm.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

On Sat, Mar 21, 2020 at 01:25:55PM -0700, Sean Christopherson wrote:
> Pass @opaque to kvm_arch_hardware_setup() and
> kvm_arch_check_processor_compat() to allow architecture specific code to
> reference @opaque without having to stash it away in a temporary global
> variable.  This will enable x86 to separate its vendor specific callback
> ops, which are passed via @opaque, into "init" and "runtime" ops without
> having to stash away the "init" ops.
> 
> No functional change intended.
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Tested-by: Cornelia Huck <cohuck@redhat.com> #s390
> Acked-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Acked-by: Paul Mackerras <paulus@ozlabs.org>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
