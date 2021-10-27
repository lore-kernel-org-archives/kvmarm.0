Return-Path: <SRS0=suDQ=PP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC097C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 14:26:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3B20260F9B
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 14:26:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3B20260F9B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A0444B1A0;
	Wed, 27 Oct 2021 10:26:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q9ztcA51miUK; Wed, 27 Oct 2021 10:26:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 009C24B15A;
	Wed, 27 Oct 2021 10:26:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FE1C4B154
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 10:26:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ggSjUklmBFzD for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Oct 2021 10:26:44 -0400 (EDT)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com
 [209.85.214.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0CD9B4B136
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 10:26:44 -0400 (EDT)
Received: by mail-pl1-f173.google.com with SMTP id v20so2114824plo.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 07:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=LMqODRZlF8nHhJs02sWnsNzJB8DCwjwV772Lcvk4X9o=;
 b=iWwrbnSH9Fky5OxBApAzRFVpTKOaMHDs7Xrzkqa4bfHRvpB9pNrmqtwX5XStYSbIol
 NG6pr6of1LmRK/X8yeBvBQ0Fz8uYI6sCKWIvgmckbalOjA8rZIStxifaaVVG+5EdlLz8
 2ckfTI/AHFWKc1rHQsrwcPVdrkLnqwK/drtGVgppY9agtMGjOEk436kI8PMz0SqSkGNT
 dkWDCvrzCBVDPIbGEr6AdGS2sCg8RuoXUFOHg6zS7uI1OSE10fKTNRuuwKsMoNZNiFkf
 iPVMGJAgypYBjZDhK8mjFm7rCt98R0DWG7pkzdEiPhkk3mMy819HFjaZfkrakLKQ8KAR
 Wy0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=LMqODRZlF8nHhJs02sWnsNzJB8DCwjwV772Lcvk4X9o=;
 b=cajBOknmmaOQiEd2AmoQqKc8jg89If9Eha9Dg5Is6sC6CrY3dS1DR8+mU2Pw3HfMrw
 SL1o6hKso21U6DPOxEvQH+xSsEGVvif/G00T3iUIpE4HbJys5HXexpdBwazlAfv/68iD
 ZYGTFGkickJik7AuMJYolRZ8T3QftDSah3AJZSftdNes58c8kHItk/rNtGLharlN89+k
 7kvNaQrvUSjWFT4S3U6r8CgC7ov7a9fXjFX+ZXemHG99YDvXeoYBAPXuvRDm01JehpMQ
 A2POBFWFNknxGnBiieEFVuXW0Eoy5riibMXNU6UPMbnTP+PIsp0XBxLOg69YIzdfy0Cp
 MiFg==
X-Gm-Message-State: AOAM5301+3M6AUjyWRnXIJxBdawhMo0SyKpx1nw5wM6o/D/0T0lklgS5
 gyo+n3+CSF8mFORyrK8qoHxQ/w==
X-Google-Smtp-Source: ABdhPJzNj2nhULmp/RR7LS0ShzDRkQdxHUhFj7X33pr1fS/jZmoi4Y5oDiGoEdEWKdZH8tXcKWxvmw==
X-Received: by 2002:a17:90b:11c2:: with SMTP id
 gv2mr5997881pjb.133.1635344802985; 
 Wed, 27 Oct 2021 07:26:42 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id n12sm37080pgh.55.2021.10.27.07.26.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 27 Oct 2021 07:26:42 -0700 (PDT)
Date: Wed, 27 Oct 2021 14:26:38 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 24/43] KVM: VMX: Drop pointless PI.NDST update when
 blocking
Message-ID: <YXlhnkp4/XJCCO0R@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-25-seanjc@google.com>
 <18e6a656-f583-0ad4-6770-9678be3f5cf4@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <18e6a656-f583-0ad4-6770-9678be3f5cf4@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm-ppc@vger.kernel.org,
 Paul Walmsley <paul.walmsley@sifive.com>, David Matlack <dmatlack@google.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Anup Patel <anup.patel@wdc.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
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

On Mon, Oct 25, 2021, Paolo Bonzini wrote:
> On 09/10/21 04:12, Sean Christopherson wrote:
> > Don't update Posted Interrupt's NDST, a.k.a. the target pCPU, in the
> > pre-block path, as NDST is guaranteed to be up-to-date.  The comment
> > about the vCPU being preempted during the update is simply wrong, as the
> > update path runs with IRQs disabled (from before snapshotting vcpu->cpu,
> > until after the update completes).
> 
> Right, it didn't as of commit bf9f6ac8d74969690df1485b33b7c238ca9f2269 (when
> VT-d posted interrupts were introduced).
> 
> The interrupt disable/enable pair was added in the same commit that
> motivated the introduction of the sanity checks:

Ya, I found that commit when digging around for different commit in the series
and forgot to come back to this changelog.  I'll incorporate this info into the
next version.

>     commit 8b306e2f3c41939ea528e6174c88cfbfff893ce1
>     Author: Paolo Bonzini <pbonzini@redhat.com>
>     Date:   Tue Jun 6 12:57:05 2017 +0200
> 
>     KVM: VMX: avoid double list add with VT-d posted interrupts
> 
>     In some cases, for example involving hot-unplug of assigned
>     devices, pi_post_block can forget to remove the vCPU from the
>     blocked_vcpu_list.  When this happens, the next call to
>     pi_pre_block corrupts the list.
> 
>     Fix this in two ways.  First, check vcpu->pre_pcpu in pi_pre_block
>     and WARN instead of adding the element twice in the list.  Second,
>     always do the list removal in pi_post_block if vcpu->pre_pcpu is
>     set (not -1).
> 
>     The new code keeps interrupts disabled for the whole duration of
>     pi_pre_block/pi_post_block.  This is not strictly necessary, but
>     easier to follow.  For the same reason, PI.ON is checked only
>     after the cmpxchg, and to handle it we just call the post-block
>     code.  This removes duplication of the list removal code.
> 
> At the time, I didn't notice the now useless NDST update.
> 
> Paolo
> 
> > The vCPU can get preempted_before_  the update starts, but not during.
> > And if the vCPU is preempted before, vmx_vcpu_pi_load() is responsible
> > for updating NDST when the vCPU is scheduled back in.  In that case, the
> > check against the wakeup vector in vmx_vcpu_pi_load() cannot be true as
> > that would require the notification vector to have been set to the wakeup
> > vector_before_  blocking.
> > 
> > Opportunistically switch to using vcpu->cpu for the list/lock lookups,
> > which presumably used pre_pcpu only for some phantom preemption logic.
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
