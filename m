Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4702C07E9D
	for <kvmarm@archiver.kernel.org>; Tue, 27 Sep 2022 16:01:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3032540FAA;
	Tue, 27 Sep 2022 12:01:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OayYK6UWMKQy; Tue, 27 Sep 2022 12:00:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7BA64B63E;
	Tue, 27 Sep 2022 12:00:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E44D4B62F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 12:00:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id stWt8tIRoHmu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2022 12:00:55 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD52B40FAA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 12:00:55 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1664294455;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=rGIrFLnvZtpmRdhvg+z0yQrnGBkLNXoFwFSYbzeyZTc=;
 b=giF6VeIXBmozkQRyaSVh+ZqOftsMGI4TGtbYMV3rQdbfNKMnJGqEKpOOq8qHOvA3mxOcyP
 RNrbEiC3+g8TTrLdZdPKuaGV33SocRUAdclBNo1Xtd1P0NMg7L3DRkuO+90jrJPU4vzST2
 /WknZsOvaoF7fdRGtix0fSh7ptoXYcs=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-151-Kf7y6DRJN2-6IPT9cOZPFw-1; Tue, 27 Sep 2022 12:00:54 -0400
X-MC-Unique: Kf7y6DRJN2-6IPT9cOZPFw-1
Received: by mail-qk1-f198.google.com with SMTP id
 r14-20020a05620a298e00b006be796b6164so7645155qkp.19
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 09:00:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=rGIrFLnvZtpmRdhvg+z0yQrnGBkLNXoFwFSYbzeyZTc=;
 b=V0RLm3D7pcPBdcIsZv8eAbEnTlXLILb1RXFHKqUP4VVOWFwr0Xys1M89ZvsSwwDrLr
 MGQ7fTXCqL/7vk3YxTMKgGTIlV7aIZbdQ3g6cVTeKhG3mZP8i6WkqM9PAZKAYKa/vUui
 p1jvi6hGkw2Swgavizxgh92Ibg5M5BtMD59YJZyCjjSsXhahJEXGrM26p2N78RgG3deI
 MbhcNzTPZg0CPWwAsxyJ/qX8phfAjAWSYUHcUQPiVrtC0/m2T+kAwHuE3qw1oKyRLQsh
 Jm74lPVR1gx7Lz8b2wJlJW51ipt+gOfYjYJGy0qJ+d37maoLDIkYFCrDzMBTDSY4uyLe
 jmHA==
X-Gm-Message-State: ACrzQf3L3eyIEC6IH5eELoaZrriB8IvF9C1Bd1OOyKUtDGNP8qpwQ59l
 crsA4Bu2ZmLxZ8pkrprX1Lf5u5m6uTd+L7xX0CgWJwP9XsCzphj8GjmBMJi3C2XVHPypUOubklB
 7o/Qw0Ahq0q/9cLsyaBT/JRU5
X-Received: by 2002:a05:620a:25d0:b0:6bb:f597:1a3 with SMTP id
 y16-20020a05620a25d000b006bbf59701a3mr18013965qko.43.1664294450895; 
 Tue, 27 Sep 2022 09:00:50 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM41yCBsVYPgNwbyDuc60G1LQ4+zhPZc9A3FDB9o9gUjW50brkagD39Cv468A4lXwLbldr4rSQ==
X-Received: by 2002:a05:620a:25d0:b0:6bb:f597:1a3 with SMTP id
 y16-20020a05620a25d000b006bbf59701a3mr18013673qko.43.1664294446386; 
 Tue, 27 Sep 2022 09:00:46 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca.
 [70.31.27.79]) by smtp.gmail.com with ESMTPSA id
 e2-20020ac84e42000000b00338ae1f5421sm1156520qtw.0.2022.09.27.09.00.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 27 Sep 2022 09:00:45 -0700 (PDT)
Date: Tue, 27 Sep 2022 12:00:42 -0400
From: Peter Xu <peterx@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v4 1/6] KVM: x86: Introduce KVM_REQ_RING_SOFT_FULL
Message-ID: <YzMeKgmJpUJFc7HJ@x1n>
References: <20220927005439.21130-1-gshan@redhat.com>
 <20220927005439.21130-2-gshan@redhat.com>
 <86y1u56rku.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <86y1u56rku.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 will@kernel.org, shan.gavin@gmail.com, bgardon@google.com, dmatlack@google.com,
 pbonzini@redhat.com, zhenyzha@redhat.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu
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

On Tue, Sep 27, 2022 at 06:26:41AM -0400, Marc Zyngier wrote:
> > +static inline bool kvm_dirty_ring_check_request(struct kvm_vcpu *vcpu)
> > +{
> > +	return false;
> > +}
> > +
> 
> nit: I don't think this is needed at all. The dirty ring feature is
> not user-selectable, and this is always called from arch code that is
> fully aware of that option.

Agreed.  With the change:

Reviewed-by: Peter Xu <peterx@redhat.com>

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
