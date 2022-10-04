Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3D333ED
	for <kvmarm@lists.linux.dev>; Tue,  4 Oct 2022 13:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664889976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1a5fI7ggkfQfFR1kPFxspjmxx+2AyvDZdYuODjfSZ6k=;
	b=gNN0pSgsFSJTJUS6afguIL1NrdDUvhvBUYfoF4msb0QXAHRJlhclVVAIVLqE6xgZ4sxMCm
	Kcuz55FBj7vCEIWpr7i6USNtdri4LZ6WXgUbWqsC+1Fyqf9EJOS9YSxdJ6vCQ1wMjP1aaF
	NTXogz23VHTloAKfv2mIR+qs9H+y5dE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-675-v_3M3v4fP-2Xu6ewOawyWg-1; Tue, 04 Oct 2022 09:26:15 -0400
X-MC-Unique: v_3M3v4fP-2Xu6ewOawyWg-1
Received: by mail-qk1-f200.google.com with SMTP id bm21-20020a05620a199500b006cf6a722b16so11551059qkb.0
        for <kvmarm@lists.linux.dev>; Tue, 04 Oct 2022 06:26:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=1a5fI7ggkfQfFR1kPFxspjmxx+2AyvDZdYuODjfSZ6k=;
        b=RGBRzzm3GttXj35P1/ph9QMCS2fVy2poMkQrk4areD2UcZUvvKG8Y8YAWtY7N3plUi
         3latZpgk9axeuCf0wul2O1Z3EmOl2N2WH+NpKJHoeFCxWTG+S4hltFliwurxUpgxOZlY
         D4rkaPc0jLumDN7A/zfj/7rCuQzJ40dyS8kU5cbUIa3KgRXy0OtjjsFoi2/2Mnb4da7f
         3FzWNYUzBWOZNjNkjf5waj8EZy80UKOn0WbhsIV6aXijtubyI7pR+L3UvpKcWQtbP9US
         szla4GUdlP8pEAxhKcE/mtOcIjiTcA46QJl3EGhQ1do52bDVgUCPHzY/8jx2C07S7UGA
         vaaw==
X-Gm-Message-State: ACrzQf33ffKGKKlrEKX7MHcFKaiyMZsJi+8QFpAtjS2sI18SpAJeGPV7
	naHweZ0DpQeJeqkV9t5r5Fd7VdwFtgxXMaDqAG4eq5aZ9oIAPHnndXmucjdO8UxgkUTSUm0rYut
	+QLqtWIqf7Aw1XClb
X-Received: by 2002:a05:622a:390:b0:35d:44ab:c615 with SMTP id j16-20020a05622a039000b0035d44abc615mr19888383qtx.594.1664889974661;
        Tue, 04 Oct 2022 06:26:14 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6M0PX+ipcJM7x33PxLdL7QLzw6bN4v+B38ziDmyGUyWyjBElmxYO5+ApuqF1XR0sZTmHhR3A==
X-Received: by 2002:a05:622a:390:b0:35d:44ab:c615 with SMTP id j16-20020a05622a039000b0035d44abc615mr19888354qtx.594.1664889974443;
        Tue, 04 Oct 2022 06:26:14 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id i10-20020ac8764a000000b0031f41ea94easm12512816qtr.28.2022.10.04.06.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 06:26:13 -0700 (PDT)
Date: Tue, 4 Oct 2022 09:26:11 -0400
From: Peter Xu <peterx@redhat.com>
To: Gavin Shan <gshan@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, catalin.marinas@arm.com, bgardon@google.com,
	shuah@kernel.org, andrew.jones@linux.dev, will@kernel.org,
	dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com,
	shan.gavin@gmail.com, james.morse@arm.com, suzuki.poulose@arm.com,
	alexandru.elisei@arm.com, oliver.upton@linux.dev,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 3/6] KVM: arm64: Enable ring-based dirty memory
 tracking
Message-ID: <Yzw0c5tD28W8L7wP@x1n>
References: <20220927005439.21130-4-gshan@redhat.com>
 <YzMerD8ZvhvnprEN@x1n>
 <86sfkc7mg8.wl-maz@kernel.org>
 <YzM/DFV1TgtyRfCA@x1n>
 <320005d1-fe88-fd6a-be91-ddb56f1aa80f@redhat.com>
 <87y1u3hpmp.wl-maz@kernel.org>
 <YzRfkBWepX2CD88h@x1n>
 <d0beb9bd-5295-adb6-a473-c131d6102947@redhat.com>
 <86fsga6y40.wl-maz@kernel.org>
 <8b82ef3d-16ab-0aee-b464-8ad9b3718028@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <8b82ef3d-16ab-0aee-b464-8ad9b3718028@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Message-ID: <20221004132611.226WOA3i8pZoy-_lBvUN6II7178wUgqkNaPMlr2HIkw@z>

On Tue, Oct 04, 2022 at 12:26:23PM +0800, Gavin Shan wrote:
> Note: for post-copy and snapshot, I assume we need to save the dirty bitmap
>       in the last synchronization, right after the VM is stopped.

Agreed on postcopy.  Note that snapshot doesn't use kvm dirty logging
because it requires synchronous events (userfaultfd), so that's not
affected by this work.  Thanks,

-- 
Peter Xu

