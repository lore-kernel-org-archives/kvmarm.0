Return-Path: <SRS0=UlWN=OR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1E7EC4332F
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 14:59:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2CEB860FF2
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 14:59:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2CEB860FF2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E37B4B0A3;
	Mon, 27 Sep 2021 10:59:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mgIjPDm2+wWO; Mon, 27 Sep 2021 10:59:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DFE240667;
	Mon, 27 Sep 2021 10:59:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CACEC4A524
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 10:59:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MbSlTxvphzSe for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Sep 2021 10:59:53 -0400 (EDT)
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com
 [209.85.215.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B4637405EE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 10:59:53 -0400 (EDT)
Received: by mail-pg1-f177.google.com with SMTP id s75so1538895pgs.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 07:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=8d5KqXA5Mi92PwzZc0N/pdrf/YfLC80LCsk313TOlF8=;
 b=m7Sxwd73+QIO2WuPaGefD2VV92Ixlana/rvgLp3fywdfnLLEysnYWnlbrJZMSHvky2
 P+dNFDKl+i/DMSPcDLNPjzckqkQLgh9pdU/c3JQwnIagXzSzhgOa+ncEZvwMUJLQWG1m
 fybm6n4GY1o2I/TIIMUtFfjJTQU9KFbL0J/XoEro7oVzMh1zw+XmI5tRZQQeuZDe42Dg
 Tmmp6oePrkChYyER1Tnna/qEz55zzNMH1ZMLBsrMQL84AaEtkyNXBlm2Xx+ZucKX/mXL
 yMhzhoMAfnJyECqCajIjTuZBzhOpC4zX9voYjWadeZj+T2l75O1okb7Y4J7XHlu7WdkY
 kHUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=8d5KqXA5Mi92PwzZc0N/pdrf/YfLC80LCsk313TOlF8=;
 b=IHwN0bJFyNKAYZWlpVqaOmnpTUrUnWYBTbRk6kcc12e6eBFUQOoiWYwJCun1FM4Oxc
 RITNbgHGf1TEPiAXY94WAeHRlnMPOvCX6JpnhdEbxDLhSt7QJJMERhLi5iJlbWuNPoei
 sw3wFCssm3orYqkouJvbWVOfNa8mntjUrU5VpTmK2Zq4h82wkWrjLdslxK1mi7awS3oB
 0xwU4p4WJnPBl71D+WkMWD57hh+zFs0qzbHCV/UOdGvoRaYf3yZ6o7n3jatqoXObzWmO
 l2ncZyKh4RVyd1f0RCgh5rysSgayVozSNVFzkX9+encWKb0UxcfybJ9x+SsVREtcDxh6
 lAlg==
X-Gm-Message-State: AOAM532DZ0kmsYnHAXQshzvK/eSw/Bv5PfroJX8pDmgtN/LUyh8CJmja
 Dli5nrHLpAlmEv+N5WeMx0GczA==
X-Google-Smtp-Source: ABdhPJyg70ia4mflauFBTnYYkPuZeGu0PUo7u3KrQoV6hyYnlf5Ujo4gsfK+PdoDvaYqAOyRoeDCGg==
X-Received: by 2002:a63:e057:: with SMTP id n23mr107748pgj.183.1632754792472; 
 Mon, 27 Sep 2021 07:59:52 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id n14sm19177569pgd.48.2021.09.27.07.59.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Sep 2021 07:59:51 -0700 (PDT)
Date: Mon, 27 Sep 2021 14:59:47 +0000
From: Sean Christopherson <seanjc@google.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: disabling halt polling broken? (was Re: [PATCH 00/14] KVM:
 Halt-polling fixes, cleanups and a new stat)
Message-ID: <YVHcY6y1GmvGJnMg@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <03f2f5ab-e809-2ba5-bd98-3393c3b843d2@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <03f2f5ab-e809-2ba5-bd98-3393c3b843d2@de.ibm.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Jon Cargille <jcargill@google.com>, kvm-ppc@vger.kernel.org,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Mon, Sep 27, 2021, Christian Borntraeger wrote:
> While looking into this series,
> 
> I realized that Davids patch
> 
> commit acd05785e48c01edb2c4f4d014d28478b5f19fb5
> Author:     David Matlack <dmatlack@google.com>
> AuthorDate: Fri Apr 17 15:14:46 2020 -0700
> Commit:     Paolo Bonzini <pbonzini@redhat.com>
> CommitDate: Fri Apr 24 12:53:17 2020 -0400
> 
>     kvm: add capability for halt polling
> 
> broke the possibility for an admin to disable halt polling for already running KVM guests.
> In past times doing
> echo 0 > /sys/module/kvm/parameters/halt_poll_ns
> 
> stopped polling system wide.
> Now all KVM guests will use the halt_poll_ns value that was active during
> startup - even those that do not use KVM_CAP_HALT_POLL.
> 
> I guess this was not intended?

Ouch.  I would go so far as to say that halt_poll_ns should be a hard limit on
the capability.  What about having the per-VM variable track only the capability,
and then use the module param to cap the max when doing adjustments?  E.g. add
a variant of this early in the series?

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 80f78daa6b8d..f50e4e31a0cf 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1078,8 +1078,6 @@ static struct kvm *kvm_create_vm(unsigned long type)
                        goto out_err_no_arch_destroy_vm;
        }

-       kvm->max_halt_poll_ns = halt_poll_ns;
-
        r = kvm_arch_init_vm(kvm, type);
        if (r)
                goto out_err_no_arch_destroy_vm;
@@ -3136,7 +3134,8 @@ void kvm_sigset_deactivate(struct kvm_vcpu *vcpu)
        sigemptyset(&current->real_blocked);
 }

-static void grow_halt_poll_ns(struct kvm_vcpu *vcpu)
+static void grow_halt_poll_ns(struct kvm_vcpu *vcpu,
+                             unsigned int max_halt_poll_ns)
 {
        unsigned int old, val, grow, grow_start;

@@ -3150,8 +3149,8 @@ static void grow_halt_poll_ns(struct kvm_vcpu *vcpu)
        if (val < grow_start)
                val = grow_start;

-       if (val > vcpu->kvm->max_halt_poll_ns)
-               val = vcpu->kvm->max_halt_poll_ns;
+       if (val > max_halt_poll_ns)
+               val = max_halt_poll_ns;

        vcpu->halt_poll_ns = val;
 out:
@@ -3261,6 +3260,7 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 {
        bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
        bool do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
+       unsigned int max_halt_poll_ns;
        ktime_t start, cur, poll_end;
        bool waited = false;
        u64 halt_ns;
@@ -3304,19 +3304,25 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
                update_halt_poll_stats(vcpu, start, poll_end, !waited);

        if (halt_poll_allowed) {
+               max_halt_poll_ns = vcpu->kvm->max_halt_poll_ns;
+               if (max_halt_poll_ns)
+                       max_halt_poll_ns = min(max_halt_poll_ns, halt_poll_ns);
+               else
+                       max_halt_poll_ns = halt_poll_ns;
+
                if (!vcpu_valid_wakeup(vcpu)) {
                        shrink_halt_poll_ns(vcpu);
-               } else if (vcpu->kvm->max_halt_poll_ns) {
+               } else if (max_halt_poll_ns) {
                        if (halt_ns <= vcpu->halt_poll_ns)
                                ;
                        /* we had a long block, shrink polling */
                        else if (vcpu->halt_poll_ns &&
-                                halt_ns > vcpu->kvm->max_halt_poll_ns)
+                                halt_ns > max_halt_poll_ns)
                                shrink_halt_poll_ns(vcpu);
                        /* we had a short halt and our poll time is too small */
-                       else if (vcpu->halt_poll_ns < vcpu->kvm->max_halt_poll_ns &&
-                                halt_ns < vcpu->kvm->max_halt_poll_ns)
-                               grow_halt_poll_ns(vcpu);
+                       else if (vcpu->halt_poll_ns < max_halt_poll_ns &&
+                                halt_ns < max_halt_poll_ns)
+                               grow_halt_poll_ns(vcpu, max_halt_poll_ns);
                } else {
                        vcpu->halt_poll_ns = 0;
                }
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
