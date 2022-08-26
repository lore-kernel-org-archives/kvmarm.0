Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 047E3ECAAD4
	for <kvmarm@archiver.kernel.org>; Fri, 26 Aug 2022 10:58:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63BEB4E38C;
	Fri, 26 Aug 2022 06:58:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MFcRnXu0P7li; Fri, 26 Aug 2022 06:58:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2ED534E38E;
	Fri, 26 Aug 2022 06:58:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DADA84E388
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Aug 2022 06:58:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NM78vVWEaj4B for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Aug 2022 06:58:31 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7CD34E387
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Aug 2022 06:58:31 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1661511511;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=jMnbTKtNSpTsqq0eZVxc5+MQ+KePmpUNSlwTet2oL2k=;
 b=eGtLDKFj7bMqPqGtzox0UOQ3E+T//5Syz7kr6b96pblaX1i0qRwQANBTFl69SxALsp6rez
 zQ0mF84CuWsTrk9mblo35rSzs9u2OYNus2riqZBdTNUnZOQ/vs8q/X0TfUUex4ZzmQ4NN3
 5pe86DAZaHJyCvi7Py0dbSLTrHAdl10=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-286-5lb9o-xNOD2X7iW3DUe4TA-1; Fri, 26 Aug 2022 06:58:30 -0400
X-MC-Unique: 5lb9o-xNOD2X7iW3DUe4TA-1
Received: by mail-ed1-f71.google.com with SMTP id
 b12-20020a056402278c00b00447f2029741so795090ede.23
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Aug 2022 03:58:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
 :content-language:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc;
 bh=jMnbTKtNSpTsqq0eZVxc5+MQ+KePmpUNSlwTet2oL2k=;
 b=sZodKpHxokQGqG6Xsf46FPRjbsGuME1oQ3pit9iNG9iZZZcuMPXJB3FJ1S9qI3S3Bp
 qBPmunVD0H9Zu+cEcdWD6iH4VbfUFKkN/z5Dj6JICozHBnyzMWKvE+/mz+9O0xrUA5P9
 Naao+qH9/PBK98N9FGzgIJllFtahS+bhU+7BgPXMoF4ODipIRrWy03m7YKWpwKvEMy62
 Z1QFbc9Qjg76heQ+dQt0gfojDulvEpbjhj2DuDGyMAqV4icYWA3oQseJmJvD2ZTFtNMi
 s+ms9mywF9RycCm9N7uZC3ordefuxCoQ0gDKCzqOUHuaAa2rI5uT+XNJjHKaeix5KtqP
 XxZQ==
X-Gm-Message-State: ACgBeo2qc7ckT5eW41PesRy5+/RwLoALmXIr4rpAr5UR0cpNku2pZTZz
 sfMr1A/YieaAKbZLbamnCFOoNjeeN35pWGg666oD+sHzV1WrAbdf1BE60VeiAW+aBXuMB0YU1Ao
 RcSBlvtKrVvpvBy1GG6D7wYF1
X-Received: by 2002:a05:6402:5150:b0:447:933d:ec65 with SMTP id
 n16-20020a056402515000b00447933dec65mr6212685edd.80.1661511508682; 
 Fri, 26 Aug 2022 03:58:28 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4J7blDIUmOh5lFPHJwf/tJLIYkgJgvljjD4T11ziyn6v4vnxonXD5Bpxyrz7ntlO6vhSx/Hw==
X-Received: by 2002:a05:6402:5150:b0:447:933d:ec65 with SMTP id
 n16-20020a056402515000b00447933dec65mr6212653edd.80.1661511508460; 
 Fri, 26 Aug 2022 03:58:28 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 p17-20020a50cd91000000b004479cec6496sm1102859edi.75.2022.08.26.03.58.09
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 26 Aug 2022 03:58:27 -0700 (PDT)
Message-ID: <99364855-b4e9-8a69-e1ca-ed09d103e4c8@redhat.com>
Date: Fri, 26 Aug 2022 12:58:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
References: <20220819005601.198436-1-gshan@redhat.com>
 <20220819005601.198436-2-gshan@redhat.com> <87lerkwtm5.wl-maz@kernel.org>
 <41fb5a1f-29a9-e6bb-9fab-4c83a2a8fce5@redhat.com>
 <87fshovtu0.wl-maz@kernel.org> <YwTn2r6FLCx9mAU7@google.com>
 <87a67uwve8.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v1 1/5] KVM: arm64: Enable ring-based dirty memory tracking
In-Reply-To: <87a67uwve8.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 linux-kselftest@vger.kernel.org, bgardon@google.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu, corbet@lwn.net, will@kernel.org,
 shan.gavin@gmail.com, drjones@redhat.com, zhenyzha@redhat.com,
 dmatlack@google.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 8/23/22 22:35, Marc Zyngier wrote:
>> Heh, yeah I need to get that out the door. I'll also note that Gavin's
>> changes are still relevant without that series, as we do write unprotect
>> in parallel at PTE granularity after commit f783ef1c0e82 ("KVM: arm64:
>> Add fast path to handle permission relaxation during dirty logging").
>
> Ah, true. Now if only someone could explain how the whole
> producer-consumer thing works without a trace of a barrier, that'd be
> great...

Do you mean this?

void kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset)
{
         struct kvm_dirty_gfn *entry;

         /* It should never get full */
         WARN_ON_ONCE(kvm_dirty_ring_full(ring));

         entry = &ring->dirty_gfns[ring->dirty_index & (ring->size - 1)];

         entry->slot = slot;
         entry->offset = offset;
         /*
          * Make sure the data is filled in before we publish this to
          * the userspace program.  There's no paired kernel-side reader.
          */
         smp_wmb();
         kvm_dirty_gfn_set_dirtied(entry);
         ring->dirty_index++;
         trace_kvm_dirty_ring_push(ring, slot, offset);
}

The matching smp_rmb() is in userspace.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
