Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60EC6FB3
	for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 23:48:16 +0000 (UTC)
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-268b931c2ceso1917561a91.3
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 16:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691711296; x=1692316096;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZV/Ct/Ds/CxS4v6ir6EHRWsoOhvufSz0INvujsP8hqY=;
        b=vSrGdjpvDxTK/XL3At5KxkEi3BN7xLVQpPmnORZMhNG6jd39wJsns/R42KS5xfvvXi
         yWOf3T02bs2cFYxM2Bhrzrfj0k6Po0wWmcQm6G/LaTfmxV81Ct/0B2yvJpQ1Ac5przBM
         YI/COf8QXx2m5sSQcKF+l2LSoIpkzb5A89S15N5HYQ3pppUclgQ+9/xmB/68xZHvAKfB
         JSU6pgtHKdHo4h0gV0hA/MMNZT85qAuZCuamTpFwYhHNi9iSZMFI/PgHP9+N4m/gs0vU
         jiL9rOS/C5ipEbZb8SH5IHTEyqot9sQ8y5Uv8dfoZAg4iBI1zrE098pJmeiz2Px/Socu
         EZ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691711296; x=1692316096;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZV/Ct/Ds/CxS4v6ir6EHRWsoOhvufSz0INvujsP8hqY=;
        b=PtIT5u7wwkrDqXiqvIdEOFUjkE6B+nut5h9WtVPA2egcntncWwawSMEWlp/nUCegZ5
         9K6aGwLLCO1EkKTNnEBSAmtioE1PSy4X8koFl7YS9EhbPsuwB6X70z431JEFSEHuPZeM
         05CVWWHeA8Bo/4F6Tfd1AFN2Px0rlsNwJ3yCOwYwAua5XplDALiWe8aQ1KYRsF3CVgcr
         6MmTl74LGEW7s8po66G+i/Vl+o2EdON4dTMVUpZhamBKuSONzpZPpeF1SIa/Uqj9JKbs
         wicyder/ydnZpx3xeCM7IR6KbEBJcM/mxXfliVvWztk8mELW7ZPsYv0slmRQwr4Z66Wl
         mlDw==
X-Gm-Message-State: AOJu0YxoevW7zavWnHbC5jCt6mlZCkiHBvQD3Q4V4bUS+a0VFiLafbSu
	1zMc7z6YmK3TgRaeGblWEdge2hAvjjU=
X-Google-Smtp-Source: AGHT+IFvQV9B4i2e4uuA2RI0E1Gm8UGPYDS/BYnwMbmvrRmW8AeG2hCnUB9az9bEpN0laGy/rlEDrxMOA1g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:811:b0:262:ffae:56cf with SMTP id
 bk17-20020a17090b081100b00262ffae56cfmr9678pjb.8.1691711296149; Thu, 10 Aug
 2023 16:48:16 -0700 (PDT)
Date: Thu, 10 Aug 2023 16:48:14 -0700
In-Reply-To: <CAF7b7mqczaqwFhFaoicOtWHGEf50f-14cuCXSPj36eZsuCoGUg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-2-amoorthy@google.com>
 <ZInRNigDyzeuf79e@google.com> <CAF7b7moOw5irHbZmjj=40H3wJ0uWK5qRhQXpxAk3k4MBg3cH3Q@mail.gmail.com>
 <CAF7b7mqczaqwFhFaoicOtWHGEf50f-14cuCXSPj36eZsuCoGUg@mail.gmail.com>
Message-ID: <ZNV3Pnqczf6PrNrs@google.com>
Subject: Re: [PATCH v4 01/16] KVM: Allow hva_pfn_fast() to resolve read-only faults.
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 10, 2023, Anish Moorthy wrote:
> I figured I'd start double checking my documentation changes before
> sending out the next version, since those have been a persistent
> issue. So, here's what I've currently got for the commit message here
> 
> > hva_to_pfn_fast() currently just fails for read faults where
> > establishing writable mappings is forbidden, which is unnecessary.
> > Instead, try getting the page without passing FOLL_WRITE. This allows
> > the aforementioned faults to (potentially) be resolved without falling
> > back to slow GUP.

Looks good!  One nit, I would drop the "read" part of "read faults".  This behavior
also applies to executable faults.  You captured the key part well (writable mappings
forbidden), so I don't think there's any need to further clarify what types of
faults this applies to.
