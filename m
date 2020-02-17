Return-Path: <SRS0=AIE7=4F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DD85C34022
	for <kvmarm@archiver.kernel.org>; Mon, 17 Feb 2020 15:45:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CFB8C22B48
	for <kvmarm@archiver.kernel.org>; Mon, 17 Feb 2020 15:45:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DiycSGBG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CFB8C22B48
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 431764AF4C;
	Mon, 17 Feb 2020 10:45:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EPvixeF6yiXj; Mon, 17 Feb 2020 10:45:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 346364AF56;
	Mon, 17 Feb 2020 10:45:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D2C24AF4C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Feb 2020 10:35:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VHcbBk2mJZOG for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Feb 2020 10:35:13 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 423214AF29
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Feb 2020 10:35:13 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581953713;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=f9k/lECSipAyKMEJyCYwRMAHJ7XyYrMgRJSZNNqcEog=;
 b=DiycSGBG4J1DVnf//UzqX9H9/eFQDkXhtrA47xybpfHnzCZVN766tj095TaHGsEWh/cBTu
 2UD3ojFbJT2TTsubkoKLoYCuz4I2us2oifgjevvpXuAHj0cP87zf1BBzDRsyVMfeexpvy/
 ex8beoivXAc54D1ChPlZM+9vP+yZ2Cw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-PDsMg9KsPuGeYn4K_fNkhw-1; Mon, 17 Feb 2020 10:35:08 -0500
Received: by mail-wr1-f70.google.com with SMTP id n23so9109783wra.20
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Feb 2020 07:35:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
 :message-id:mime-version;
 bh=I94s+/OW2nmFtGVziJ+53lmgRDQEQNRHpvcvNRvPjFg=;
 b=okVhWe4OtcIalLKfbivTFdge+X6yLvc3PCnIL2l3tijEEnd7T8opKmo8PY714WhI3w
 iozbLKaEQ6+y8kUsU1rTvgxuvZiR5ff9Q907D/qzzCwyM+C6Y7OrJEezljeyR/0XUxBC
 AdikS8RNj0h7Y9zccA8WJkDbnQ2WfsHw468wmmb4gaEvLzmkK1b860oLCThS3frvy29f
 GnS1gQ7CElFjgaBhFzEKdlDU9r87/MGms8fEqC8CzPPO47sea2/nvvvd4GhxP1gC/f5L
 XSaeJuxTDL2ojMQPMIoyjyJ28p16ghodQR/NB1NjbDQrLRWGIYxx4k+msS8jeV6R100q
 BHMA==
X-Gm-Message-State: APjAAAWBYooapmGbUJ9M5NOlB+7w8xMq6qm85bJjKm7refjrY6YjAXX0
 KBcGxs6Wb95tGQHahq3vLTPxgQM5EOAKgM6v5H0dYaJqO+3j2Ek8ezR1KIQRPMNDE5s4QPRfwEx
 3r8DsL+kFiU8ht86gJs5BxJin
X-Received: by 2002:a7b:cd8e:: with SMTP id y14mr22883677wmj.150.1581953707731; 
 Mon, 17 Feb 2020 07:35:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqw70CrrrSfMwVWl7qnn5bAkrGx2tWvnt4qyiyI0/zrMUKDzlnUG9J1tN9btzikV0/JwRnl8xw==
X-Received: by 2002:a7b:cd8e:: with SMTP id y14mr22883657wmj.150.1581953707447; 
 Mon, 17 Feb 2020 07:35:07 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com.
 [213.175.37.10])
 by smtp.gmail.com with ESMTPSA id y8sm1018221wma.10.2020.02.17.07.35.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 17 Feb 2020 07:35:06 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>,
 Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v5 15/19] KVM: Provide common implementation for generic
 dirty log functions
In-Reply-To: <20200207194532.GK2401@linux.intel.com>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-16-sean.j.christopherson@intel.com>
 <20200206200200.GC700495@xz-x1> <20200206212120.GF13067@linux.intel.com>
 <20200206214106.GG700495@xz-x1> <20200207194532.GK2401@linux.intel.com>
Date: Mon, 17 Feb 2020 16:35:05 +0100
Message-ID: <87v9o59qhi.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-MC-Unique: PDsMg9KsPuGeYn4K_fNkhw-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Mon, 17 Feb 2020 10:45:16 -0500
Cc: Wanpeng Li <wanpengli@tencent.com>, Janosch Frank <frankja@linux.ibm.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
 linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> +Vitaly for HyperV
>
> On Thu, Feb 06, 2020 at 04:41:06PM -0500, Peter Xu wrote:
>> On Thu, Feb 06, 2020 at 01:21:20PM -0800, Sean Christopherson wrote:
>> > On Thu, Feb 06, 2020 at 03:02:00PM -0500, Peter Xu wrote:
>> > > But that matters to this patch because if MIPS can use
>> > > kvm_flush_remote_tlbs(), then we probably don't need this
>> > > arch-specific hook any more and we can directly call
>> > > kvm_flush_remote_tlbs() after sync dirty log when flush==true.
>> > 
>> > Ya, the asid_flush_mask in kvm_vz_flush_shadow_all() is the only thing
>> > that prevents calling kvm_flush_remote_tlbs() directly, but I have no
>> > clue as to the important of that code.
>> 
>> As said above I think the x86 lockdep is really not necessary, then
>> considering MIPS could be the only one that will use the new hook
>> introduced in this patch...  Shall we figure that out first?
>
> So I prepped a follow-up patch to make kvm_arch_dirty_log_tlb_flush() a
> MIPS-only hook and use kvm_flush_remote_tlbs() directly for arm and x86,
> but then I realized x86 *has* a hook to do a precise remote TLB flush.
> There's even an existing kvm_flush_remote_tlbs_with_address() call on a
> memslot, i.e. this exact scenario.  So arguably, x86 should be using the
> more precise flush and should keep kvm_arch_dirty_log_tlb_flush().
>
> But, the hook is only used when KVM is running as an L1 on top of HyperV,
> and I assume dirty logging isn't used much, if at all, for L1 KVM on
> HyperV?

(Sorry for the delayed reply, was traveling last week)

When KVM runs as an L1 on top of Hyper-V it uses eVMCS by default and
eVMCSv1 doesn't support PML. I've also just checked Hyper-V 2019 and it
hides SECONDARY_EXEC_ENABLE_PML from guests (this was expected).

>
> I see three options:
>
>   1. Make kvm_arch_dirty_log_tlb_flush() MIPS-only and call
>      kvm_flush_remote_tlbs() directly for arm and x86.  Add comments to
>      explain when an arch should implement kvm_arch_dirty_log_tlb_flush().
>
>   2. Change x86 to use kvm_flush_remote_tlbs_with_address() when flushing
>      a memslot after the dirty log is grabbed by userspace.
>
>   3. Keep the resulting code as is, but add a comment in x86's
>      kvm_arch_dirty_log_tlb_flush() to explain why it uses
>      kvm_flush_remote_tlbs() instead of the with_address() variant.
>
> I strongly prefer to (2) or (3), but I'll defer to Vitaly as to which of
> those is preferable.

I'd vote for (2): while this will effectively be kvm_flush_remote_tlbs()
for now, we may think of something smarter in the future (e.g. PV
interface for KVM-on-KVM).

>
> I don't like (1) because (a) it requires more lines code (well comments),
> to explain why kvm_flush_remote_tlbs() is the default, and (b) it would
> require even more comments, which would be x86-specific in generic KVM,
> to explain why x86 doesn't use its with_address() flush, or we'd lost that
> info altogether.
>

-- 
Vitaly

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
