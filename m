Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F42863CF
	for <kvmarm@lists.linux.dev>; Thu,  3 Nov 2022 19:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667504007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bHrHw67H9V40qrnDXssLTsxUZ9uLutx6BAx0o7ln+HQ=;
	b=KejkPwYt2au5GpvN1Qh0KA878HSbh5EnK/i74TDp2gOWCjZJLPDhLfKx90ZZwEMsOgSnBE
	XQEQeP4aEx8naeddq/VBgIKWKglmkNfC5gdYS5lvDXHlWJU/2Y4ff+iqU6qQ6afDzkqcoJ
	BX0ZUnB4Stg0LKswanX7sEEVaIvpdfk=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-18-R14Pp8gxNliAX59tI00Qdw-1; Thu, 03 Nov 2022 15:33:26 -0400
X-MC-Unique: R14Pp8gxNliAX59tI00Qdw-1
Received: by mail-qt1-f200.google.com with SMTP id fp9-20020a05622a508900b003a503ff1d4cso2495427qtb.22
        for <kvmarm@lists.linux.dev>; Thu, 03 Nov 2022 12:33:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bHrHw67H9V40qrnDXssLTsxUZ9uLutx6BAx0o7ln+HQ=;
        b=DEfd0Gt7aMiv+HUAMqH0krSgyabJeUMNaedJNB2mF3kGSoN1gap3t36gZlYMpiT5Kw
         tZoD9uVUmpvYnc52gy6eufU/fKCPCdc4ebRt/pvtw8ukcxD7yIhQ2vAfznJHozxoCW7b
         2plzmMbP9qkNJOQM33XO9UM3EYQcXDatHP6QqRnPlPxMKYLNjLn27EY791Pf9XBOSIlL
         CgdeMk5Qsx1ixazZtENWOH0ngOTw3Q9gPeeClQXSOcEEwawk8Quw8yCKFMAFiElbuJAq
         RanF4Fj6s7mzH3g5R6u8186ZyvnmCGe5pE1RDE+b+2vFccOlIHWb9PpaiTnqKkQHX2yw
         a53w==
X-Gm-Message-State: ACrzQf23OJNjs74R2LeT7JPdISiry0smjLF3UMM1Yv9x8l81EzB+P16S
	dCmVYXrJEPTtPjqRSGWRLTXF2F/1lIP/vQe9h8/mtadDqHC3WSlXnbKtuf0uN51x/Byu+VVJX2P
	ZLQ1q/f4/fq8RuO/F
X-Received: by 2002:ac8:4e89:0:b0:39c:c025:887a with SMTP id 9-20020ac84e89000000b0039cc025887amr26208776qtp.413.1667504005640;
        Thu, 03 Nov 2022 12:33:25 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4R+CVRPC2arwivP79Qld/IvHiKE/cb49gnSORd3djcfXtq8j0yR40+W1k4QyB1f4cAEtdMdA==
X-Received: by 2002:ac8:4e89:0:b0:39c:c025:887a with SMTP id 9-20020ac84e89000000b0039cc025887amr26208742qtp.413.1667504005412;
        Thu, 03 Nov 2022 12:33:25 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id h4-20020a05620a400400b006eea4b5abcesm1353401qko.89.2022.11.03.12.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 12:33:24 -0700 (PDT)
Date: Thu, 3 Nov 2022 15:33:23 -0400
From: Peter Xu <peterx@redhat.com>
To: Gavin Shan <gshan@redhat.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
	ajones@ventanamicro.com, maz@kernel.org, bgardon@google.com,
	catalin.marinas@arm.com, dmatlack@google.com, will@kernel.org,
	pbonzini@redhat.com, oliver.upton@linux.dev, seanjc@google.com,
	james.morse@arm.com, shuah@kernel.org, suzuki.poulose@arm.com,
	alexandru.elisei@arm.com, zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v7 4/9] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2QXg5BMl8lMufro@x1n>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-5-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20221031003621.164306-5-gshan@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Message-ID: <20221103193323.0d0pFA5NrPxzLIxTQF-Oji55MnhrQvYfWzyRDxzdBAw@z>

On Mon, Oct 31, 2022 at 08:36:16AM +0800, Gavin Shan wrote:
> ARM64 needs to dirty memory outside of a VCPU context when VGIC/ITS is
> enabled. It's conflicting with that ring-based dirty page tracking always
> requires a running VCPU context.
> 
> Introduce a new flavor of dirty ring that requires the use of both VCPU
> dirty rings and a dirty bitmap. The expectation is that for non-VCPU
> sources of dirty memory (such as the VGIC/ITS on arm64), KVM writes to
> the dirty bitmap. Userspace should scan the dirty bitmap before migrating
> the VM to the target.
> 
> Use an additional capability to advertise this behavior. The newly added
> capability (KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP) can't be enabled before
> KVM_CAP_DIRTY_LOG_RING_ACQ_REL on ARM64. In this way, the newly added
> capability is treated as an extension of KVM_CAP_DIRTY_LOG_RING_ACQ_REL.
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Suggested-by: Peter Xu <peterx@redhat.com>
> Co-developed-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Gavin Shan <gshan@redhat.com>

Acked-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

