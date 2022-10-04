Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B33D5C4332F
	for <kvmarm@archiver.kernel.org>; Tue,  4 Oct 2022 13:26:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BD9C49F3B;
	Tue,  4 Oct 2022 09:26:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WTt7HU3escdG; Tue,  4 Oct 2022 09:26:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E93BB407BA;
	Tue,  4 Oct 2022 09:26:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EDA9406E7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Oct 2022 09:26:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8iFfzsCm4hsN for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Oct 2022 09:26:16 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D843D40162
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Oct 2022 09:26:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1664889976;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=1a5fI7ggkfQfFR1kPFxspjmxx+2AyvDZdYuODjfSZ6k=;
 b=gNN0pSgsFSJTJUS6afguIL1NrdDUvhvBUYfoF4msb0QXAHRJlhclVVAIVLqE6xgZ4sxMCm
 Kcuz55FBj7vCEIWpr7i6USNtdri4LZ6WXgUbWqsC+1Fyqf9EJOS9YSxdJ6vCQ1wMjP1aaF
 NTXogz23VHTloAKfv2mIR+qs9H+y5dE=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-341-64VILa2UPw-xohniueFjYw-1; Tue, 04 Oct 2022 09:26:15 -0400
X-MC-Unique: 64VILa2UPw-xohniueFjYw-1
Received: by mail-qt1-f200.google.com with SMTP id
 e22-20020ac84b56000000b0035bb64ad562so9323152qts.17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Oct 2022 06:26:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=1a5fI7ggkfQfFR1kPFxspjmxx+2AyvDZdYuODjfSZ6k=;
 b=1fHLfTZoQpHI52rqqzWFrJJ+p2t2PPg7p9Nxh8puuKEwSB0e0Ta/6SbyyyG4zbf0ei
 o7SkeD9lqdC4iQRcXjolBgA3n8TwLspJocMkSpPtTHCxL5auoFepfOti9nsOJzxjzy2Y
 duypOKjhcu1F39nbU/X73RuRsa2BkXAzti+v0GZVKZlZy9udl1XTpA3N4QcF4QNMfIOD
 Vg7In9El6CKXtiVVaZ4YvHSs7anA1aAXu2tIaMLPFrVZxU5Btov3ZNYQ02Q1ALkaaRNd
 PRFmYXo9GdR7O4s8FYRTQ9rbD6bOWK4IZucz+M1h1Isjb+GLPw/wYQXBM9hgVQWGKSaM
 al8Q==
X-Gm-Message-State: ACrzQf3wqY+X2sotR/tF4D/6SnfatZcmxLpy9xshs9Vzk+6A1qT1aRZn
 FDDqbdM47AGijxLiGCmI6Y9xYmD5M8MhR1ukIfXDpMJjVDdtHAShEEw7VYvVtr05UnmZUV4L5co
 u+UZo1V7fUtXVYEDOPCM+AKE4
X-Received: by 2002:a05:622a:390:b0:35d:44ab:c615 with SMTP id
 j16-20020a05622a039000b0035d44abc615mr19888384qtx.594.1664889974662; 
 Tue, 04 Oct 2022 06:26:14 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6M0PX+ipcJM7x33PxLdL7QLzw6bN4v+B38ziDmyGUyWyjBElmxYO5+ApuqF1XR0sZTmHhR3A==
X-Received: by 2002:a05:622a:390:b0:35d:44ab:c615 with SMTP id
 j16-20020a05622a039000b0035d44abc615mr19888354qtx.594.1664889974443; 
 Tue, 04 Oct 2022 06:26:14 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca.
 [70.31.27.79]) by smtp.gmail.com with ESMTPSA id
 i10-20020ac8764a000000b0031f41ea94easm12512816qtr.28.2022.10.04.06.26.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 04 Oct 2022 06:26:13 -0700 (PDT)
Date: Tue, 4 Oct 2022 09:26:11 -0400
From: Peter Xu <peterx@redhat.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 3/6] KVM: arm64: Enable ring-based dirty memory tracking
Message-ID: <Yzw0c5tD28W8L7wP@x1n>
References: <20220927005439.21130-4-gshan@redhat.com> <YzMerD8ZvhvnprEN@x1n>
 <86sfkc7mg8.wl-maz@kernel.org> <YzM/DFV1TgtyRfCA@x1n>
 <320005d1-fe88-fd6a-be91-ddb56f1aa80f@redhat.com>
 <87y1u3hpmp.wl-maz@kernel.org> <YzRfkBWepX2CD88h@x1n>
 <d0beb9bd-5295-adb6-a473-c131d6102947@redhat.com>
 <86fsga6y40.wl-maz@kernel.org>
 <8b82ef3d-16ab-0aee-b464-8ad9b3718028@redhat.com>
MIME-Version: 1.0
In-Reply-To: <8b82ef3d-16ab-0aee-b464-8ad9b3718028@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: catalin.marinas@arm.com, kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 andrew.jones@linux.dev, kvmarm@lists.linux.dev, will@kernel.org,
 shan.gavin@gmail.com, bgardon@google.com, dmatlack@google.com,
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

On Tue, Oct 04, 2022 at 12:26:23PM +0800, Gavin Shan wrote:
> Note: for post-copy and snapshot, I assume we need to save the dirty bitmap
>       in the last synchronization, right after the VM is stopped.

Agreed on postcopy.  Note that snapshot doesn't use kvm dirty logging
because it requires synchronous events (userfaultfd), so that's not
affected by this work.  Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
