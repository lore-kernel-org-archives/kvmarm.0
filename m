Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0331F15A3
	for <kvmarm@lists.linux.dev>; Tue, 11 Oct 2022 00:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665447633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rVV+6Wph3bAh4tPNroZhezVIi89kwJLdBTdHtGxU0T0=;
	b=X9pd+nfJ4z8HeQCd9NglpvtpnYtifFz9QxbJEQXKtMKC6WEj1WhSOIWmmoIShAv7E6JRfr
	n6phZ346qfzn+T2USCfumHuwkHNAp8fQZmNKI7qDRVf6CGSxNJ7/eulMxTpdHinc0IkCfV
	AifG+d6Mh+xpYs1Mit7Aq41MWgL/pKc=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-269-tQYN6aGNMje3iA3cISNyag-1; Mon, 10 Oct 2022 20:20:32 -0400
X-MC-Unique: tQYN6aGNMje3iA3cISNyag-1
Received: by mail-qt1-f199.google.com with SMTP id b12-20020a05622a020c00b003983950639bso4102735qtx.16
        for <kvmarm@lists.linux.dev>; Mon, 10 Oct 2022 17:20:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rVV+6Wph3bAh4tPNroZhezVIi89kwJLdBTdHtGxU0T0=;
        b=vG2q/fq5LQp0RgvaeCVheZDDhUzkqwAu4kCPN2iN5KIQpK7yQnR0PBhb5lscEF8IHn
         KO7t2bqLkM0gI7GYPrOfH92CYXsdp3aGf652qLKS9ZAPCtMYmD7L0ZiQU1PS/8XqZkfo
         DW9eHLwhjkgX6gJBlc5uSIAu+rSdig02qUViuhPjcE68C3MYz01BF6I0ICKtpSN6mmEI
         EYXRWNOa2A50UEbU66RbAAJd4OShwGUhhOEK2qvphWsjOEcfv6DJyJyYNyqHWcaFJsIb
         fTA5FXQodFKxy5TOKjsJ7GEZYuN+UGyi2xG5zN7m+VPl+ubxukQXFF/bqrMrc9PXGE8T
         vg2A==
X-Gm-Message-State: ACrzQf0WQ3fPHYIFFYDE/4QPYUS6wyKpba9e7WLW2u2a3zeyMhSmcTNu
	ZZiZBDliQhln0fV7OhfbIHxKZbzz3OV0uPu09h0aRSqe7GOI30uJMXYWTDFMlw4bRVIb/cHJaHW
	+eUhkOzWgQuTvp8SR
X-Received: by 2002:ad4:5c85:0:b0:4b3:cac2:d5c1 with SMTP id o5-20020ad45c85000000b004b3cac2d5c1mr13650811qvh.116.1665447632107;
        Mon, 10 Oct 2022 17:20:32 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4APqlKaeubLmKzZv8PniURDxG3Aan94kqA3Nfb19HmD+OXgHG0Yf2LeCneMPb1rOCBmvdDWg==
X-Received: by 2002:ad4:5c85:0:b0:4b3:cac2:d5c1 with SMTP id o5-20020ad45c85000000b004b3cac2d5c1mr13650793qvh.116.1665447631931;
        Mon, 10 Oct 2022 17:20:31 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id d12-20020a05620a240c00b006cf8fc6e922sm11430594qkn.119.2022.10.10.17.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 17:20:31 -0700 (PDT)
Date: Mon, 10 Oct 2022 20:20:29 -0400
From: Peter Xu <peterx@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
	catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
	andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
	pbonzini@redhat.com, zhenyzha@redhat.com, james.morse@arm.com,
	suzuki.poulose@arm.com, alexandru.elisei@arm.com, seanjc@google.com,
	shan.gavin@gmail.com
Subject: Re: [PATCH v5 3/7] KVM: x86: Allow to use bitmap in ring-based dirty
 page tracking
Message-ID: <Y0S2zY4G7jBxVgpu@xz-m1.local>
References: <20221005004154.83502-1-gshan@redhat.com>
 <20221005004154.83502-4-gshan@redhat.com>
 <Yz86gEbNflDpC8As@x1n>
 <a5e291b9-e862-7c71-3617-1620d5a7d407@redhat.com>
 <Y0A4VaSwllsSrVxT@x1n>
 <Y0SoX2/E828mbxuf@google.com>
 <Y0SvexjbHN78XVcq@xz-m1.local>
 <Y0SxnoT5u7+1TCT+@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Y0SxnoT5u7+1TCT+@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Message-ID: <20221011002029.nyAlXCg8EgV9jKEQBPfFc4NwD2boPEgJDhtuBuUSm74@z>

On Mon, Oct 10, 2022 at 11:58:22PM +0000, Oliver Upton wrote:
> I think this further drives the point home -- there's zero need for the
> bitmap with dirty ring on x86, so why even support it? The proposal of
> ALLOW_BITMAP && DIRTY_RING should be arm64-specific. Any other arch that
> needs to dirty memory outside of a vCPU context can opt-in to the
> behavior.

Yeah that sounds working too, but it'll be slightly hackish as then the
user app will need some "#ifdef ARM64" blocks for e.g. sync dirty bitmap.
With the new cap the user app can implement the whole ring with generic
code.

Also more flexible to expose it as generic cap? E.g., one day x86 can
enable this too for whatever reason (even though I don't think so..).

-- 
Peter Xu

