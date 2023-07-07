Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFEB5385
	for <kvmarm@lists.linux.dev>; Fri,  7 Jul 2023 17:35:59 +0000 (UTC)
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-47e4d002e0bso858451e0c.0
        for <kvmarm@lists.linux.dev>; Fri, 07 Jul 2023 10:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688751358; x=1691343358;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k32j4a8QbpnW53Pf3SJsom1ArrFeeJaQ6sfNzVvKozI=;
        b=gOUxjYtKmemM9rSwFVqBwsrvvDaXtY1CAJ62wNFZkyKxytUkU5E67ToCQH1kDCKbI1
         2bNvtE80A9p/dNMBuAnWS6+sZBue0RagX+fKzRWJThtxugrQudn8QAnkxR/aNTmOWP1s
         30ptnlfJrnMg8TItc5drxmcfveEOljNn1gjN//82zCg5ZQctghFiGlRrE0P6RQjZO+Rb
         6bksyYCw2Pm8qUbvjsdg8GnjxfYSJUIZ3UG1kXe8lN1FgoRR8ZkaSe9xqUMPuvxpPwIA
         Q5Vrrj1zKdNIIRbrtTSGtJE4ok8m2OIDPIaecMppwwdIuGKi5reQ2T8R29y+ehT6n7W1
         Wg9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688751358; x=1691343358;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k32j4a8QbpnW53Pf3SJsom1ArrFeeJaQ6sfNzVvKozI=;
        b=Td8zvO/a2ZRL5ptcRmZ+5zVDzIrAGvpPOYJQp9eiyJjkM18/AADmq9edBX3x31Tp2/
         1d16Cgs8cHTNzoWKL43+qJp3vMVXA4F9HUJ6aq7epzevcuIzAJvzbO5KAhps4wquHNyB
         +ncH7PvcfeGl0NM3K1GWJ4x1QSa/uPYy9Z1MUcgaBw47gon8XG6XP69lh29K4fmN7azy
         tyrHaoJEnP3z5UZQGiVUvRTbA1nx6Z69IjYTcJZTJ1/47hI14fi6vRWsI4iLYZFJzVTq
         AGtvhm5oNQMvxuZZd4sONvQ2wHLaGUS7Y6Ct1gHJiw3e7tYjx31jYICdXEieZerm10Kr
         GuVA==
X-Gm-Message-State: ABy/qLZnSJfc6fSGd4R8AanklvyoAvy4dj1NTIgslSXvlTkoqbbsp16m
	nOmFnaQa84kMOgRBYJWKceoynhK4QlXeT0xOUIwsuQ==
X-Google-Smtp-Source: APBJJlFA7kuw3wNahT9JybNFRocuZb5lWG68SxruTTjYJuWfiHBf1ZbEk1fvMQGWHBQdFDX1LvSvsG1Lm5AeiXVoh8k=
X-Received: by 2002:a1f:5cc2:0:b0:471:8bf8:3d59 with SMTP id
 q185-20020a1f5cc2000000b004718bf83d59mr4448306vkb.8.1688751358687; Fri, 07
 Jul 2023 10:35:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-7-amoorthy@google.com>
 <ZIoTWOmM2a3iVDAi@google.com>
In-Reply-To: <ZIoTWOmM2a3iVDAi@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Fri, 7 Jul 2023 10:35:23 -0700
Message-ID: <CAF7b7mqO1tJ1PwQ3NzN19mSFmVQ+wy1HB8XVLJdFzdGahyrPDQ@mail.gmail.com>
Subject: Re: [PATCH v4 06/16] KVM: Annotate -EFAULTs from kvm_vcpu_read_guest_page()
To: Sean Christopherson <seanjc@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"

Done, and same question/comment as the "write" patch (though I'm sure
we'll just keep all the discussion there henceforth)
