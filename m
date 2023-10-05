Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD9614001
	for <kvmarm@lists.linux.dev>; Thu,  5 Oct 2023 23:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iSjyIA78"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-57b5ef5b947so920789eaf.0
        for <kvmarm@lists.linux.dev>; Thu, 05 Oct 2023 16:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696547034; x=1697151834; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GOzZRCKO7Xll/sARcXB2ndjpn0IClscKumkt8MaJ4qo=;
        b=iSjyIA78ZLIv6EEB47m/hVJW8vwdHCQTBDvLYibTTky/p3nY/9nTNg6IF53U5sn7xY
         3sVLz7Eu9bE+ByblSANC1gWtua9EtU2jPeegII3F5A9vN5O7OicuOtCGDyc7JnPt0TPi
         RfBYKh83L1Zs7AbWSkL9bIEVITqgxlZwKcx8Pj7zc4l5X3ijRwqSiGiGxmuMSD0FWyit
         TzDOZ0vYooTTm8kz3kMBqxdcM6zr4ifjR4l8AVBCWbIAWuB78AsU5Kc1O61An2P7Oe2R
         BhQvSooeowbkPBUSqtXKerc+G2GpUTimSCP5MQ2wwPKzwlZn9ui074+ueMdseXGYlU1I
         zTEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696547034; x=1697151834;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GOzZRCKO7Xll/sARcXB2ndjpn0IClscKumkt8MaJ4qo=;
        b=CZRX7ZZs0gDarKsFAlIqJNsJ86+CeDjM21O2PvaWYdDNbciR8kJUOIQM6NXM81stdc
         42BphOsnclC/RE3Z+yx3SSJmpRsuwLfnnkNcdWGb1kpUDOp9QQsdMQ1IB1iMDqGBD8rb
         5tdFiyslkrG75jH7ZpGISP2Yg5hc8gH6EqmHxkAQAckEivy73vxeHNs8NqtpmYJGPMm9
         JaoFzHKyQCtssONkL3Da7Yo+G9TqmuR6VC+6u/vDWJ1JzRQB04EDiQ0BdEZ8mU8TYWtX
         O3EvdQ89eMBN8yE+jQibnr3gSA6RPrXqashCilZ8h5tk9tC4pVxUtd6Mvj8DP17118b9
         0nuQ==
X-Gm-Message-State: AOJu0YxTD+1rBG9QJ+fmsbdvjUXAkFz6yv/P9KJ2iun+1RtzybQQBW2J
	EPEcNWlBeso3zEfMYQzm5bZzREU11qoMoFM5JfRGlONVQ3JEW9SvW+CfCI8J
X-Google-Smtp-Source: AGHT+IHBBIc3dqlKzgt4G6XEK3q9QVBUjB3hE4QN7O80/SFjgK5pI7utYm61Zz8NTxMYdUxk8iLPJy1zn4a/nJ8Zpxo=
X-Received: by 2002:a4a:3447:0:b0:571:1fad:ebdb with SMTP id
 n7-20020a4a3447000000b005711fadebdbmr7016005oof.3.1696547033774; Thu, 05 Oct
 2023 16:03:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-6-amoorthy@google.com>
In-Reply-To: <20230908222905.1321305-6-amoorthy@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 5 Oct 2023 16:03:17 -0700
Message-ID: <CAF7b7mrC_gX1OQhk3cEr3M3rMQU2v-hwF_jpXORjnZ2acsNyOA@mail.gmail.com>
Subject: Re: [PATCH v5 05/17] KVM: Annotate -EFAULTs from kvm_vcpu_read/write_guest_page()
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

Dropping as per
https://lore.kernel.org/kvm/ZR88w9W62qsZDro-@google.com/. Take that,
kernel test robot!
