Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FA3C43334
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jun 2022 10:33:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DBB24B281;
	Fri, 17 Jun 2022 06:33:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wEwYQ5+dIBTW; Fri, 17 Jun 2022 06:33:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0299F4B292;
	Fri, 17 Jun 2022 06:33:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FED94B281
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 06:33:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kIAy7oTSwCiG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jun 2022 06:33:24 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 179F64B24A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 06:33:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1655462003;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=4agzDTCER7rdHfK9xEQMzlQ0F9uL187IL7/5zBBr5xY=;
 b=UCAyGOJ/FzbVD7ZauXlMcIEWJYATiAXidd35n6SeMcPa7haYB9kTc/gP0jXD7MQ1zZ67gu
 MHGmyn108OZkcRat2xlMWfFtI9edE0ukzY+C6XbcDtmUhWuTeu9GTfZSR+A6i2A8aM5l5V
 rY2wHBqWxDTnFaR/cHqIEUn/p3+HgPc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-jd70fjx7PGijF4TZu2vWIg-1; Fri, 17 Jun 2022 06:33:20 -0400
X-MC-Unique: jd70fjx7PGijF4TZu2vWIg-1
Received: by mail-ed1-f69.google.com with SMTP id
 w14-20020a056402268e00b0043556edda4dso2361807edd.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 03:33:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=4agzDTCER7rdHfK9xEQMzlQ0F9uL187IL7/5zBBr5xY=;
 b=T0knObN4jTzfR4vSooHCUTMNa85rjHTKWnKPdH5PSWHIar7Y7uudYaVlU9/6hfZ4Dl
 9t46yDlL+Ro1WjbFmKjzQpF7rPRyD8tUpK3+zzRhySjo/fGC0HBzvYHfM/jhND3nCcZx
 oKLkU7xG+UNZ26wgnxh/SL6qCDC2t5SuI6kO4PPxJ0VU2UzHXYIY5Wu5Lm/eg9aWTRC6
 x9VvzAZSR0GR61SphQYXeFS3DqRHXdMZEGiCdAEu/BwAYT6ntn5bqGxo+x567t2iVjuM
 2NiVHvBxD880UyYyLVDOl2Ho5I3Hsgp+vcpk8AC7nDvg83afn0IorpEmr61LiwTfYpaI
 Oo4A==
X-Gm-Message-State: AJIora/ieEdMaEitZ5xzrZ+flCHP6q28diviXyI5MsVAVxLI+3EEPg5k
 UqzxKKcZAR/TKT14kaaBtl0BO8Mxl59Tib52byqu1U6MP3TU1keEA5u2Or0bha+VeQytta9Y8yT
 Om4Dh7LUhwq72uqecEgC2zEuu
X-Received: by 2002:a05:6402:35d0:b0:42e:1a76:67ae with SMTP id
 z16-20020a05640235d000b0042e1a7667aemr11561001edc.311.1655461999089; 
 Fri, 17 Jun 2022 03:33:19 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tCykb5UQbKoI7sToR1CZ+4BREl9409mSObZpm6XzU2emhgekp7acvjD3jaE9eVssfSJU85hQ==
X-Received: by 2002:a05:6402:35d0:b0:42e:1a76:67ae with SMTP id
 z16-20020a05640235d000b0042e1a7667aemr11560973edc.311.1655461998827; 
 Fri, 17 Jun 2022 03:33:18 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
 by smtp.gmail.com with ESMTPSA id
 h7-20020a05640250c700b004315f96fd24sm3687810edb.31.2022.06.17.03.33.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Jun 2022 03:33:18 -0700 (PDT)
Date: Fri, 17 Jun 2022 12:33:16 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [Question] remote_tlb_flush statistic is missed from
 kvm_flush_remote_tlbs() ?
Message-ID: <20220617103316.4rejrhxtew7meawb@gator>
References: <25c7cc69-64ef-d42b-dc0b-968d7415b111@redhat.com>
 <87wndf383z.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87wndf383z.wl-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Paolo Bonzini <pbonzini@redhat.com>
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

On Fri, Jun 17, 2022 at 11:19:28AM +0100, Marc Zyngier wrote:
> On Fri, 17 Jun 2022 11:02:44 +0100,
> Gavin Shan <gshan@redhat.com> wrote:
> > 
> > Hi Folks,
> > 
> > We're reviewing upstream commits and found that it seems that
> > ++kvm->stat.generic.remote_tlb_flush has been missed from
> > kvm_flush_remote_tlbs(). If I'm correct, we still need to
> > increase the statistic in kvm_flush_remote_tlbs()?
> > 
> > History about the changes:
> > 
> > ce6a7007048b staging: r8188eu: remove {read,write}_macreg
> >     The changes were NOT there any more.
> > 419025b3b419 Merge branch kvm-arm64/misc-5.15 into kvmarm-master/next
> >     The changes were still there
> > 38f703663d4c KVM: arm64: Count VMID-wide TLB invalidations
> >     The changes were initially introduced by this commit,
> >     to increase 'kvm->stat.generic.remote_tlb_flush' in
> >     kvm_flush_remote_tlbs().
> 
> I'm not sure what you are asking. This change is definitely still
> present in the upstream kernel, and I don't get your point with the
> staging commit, which is totally unrelated.
> 
> $ git describe --contains ce6a7007048b --match=v\*
> v5.15-rc1~154^2~11
> $ git describe --contains 419025b3b419 --match=v\*
> v5.15-rc1~65^2~4^2
> $ git describe --contains 38f703663d4c --match=v\*
> v5.15-rc1~65^2~4^2^2~13
> 
> As you can see, the commit fixing the statistics was merged after
> staging one (it appears closer to -rc1, as there is 6 days between the
> two merge commits from Linus).
>

Hi Marc,

I don't see the change for commit 38f703663d4c as of an upstream pull
right now

$ git show 47700948a4ab:arch/arm64/kvm/mmu.c | grep -A4 'void kvm_flush_remote_tlbs'
void kvm_flush_remote_tlbs(struct kvm *kvm)
{
	++kvm->stat.generic.remote_tlb_flush_requests;
	kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
}

and I do see it got dropped with merge commit e99314a340d2.

$ git diff 419025b3b419 0d0a19395baa -- arch/arm64/kvm/mmu.c | grep -A5 'void kvm_flush_remote_tlbs'
 void kvm_flush_remote_tlbs(struct kvm *kvm)
 {
+	++kvm->stat.generic.remote_tlb_flush_requests;
 	kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
-	++kvm->stat.generic.remote_tlb_flush;
 }

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
