Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13363B2FDF
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 14:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784556253; cv=none; b=Q37KYmYkadel6xi4sUWtz1E0fpvZFwfc4V0M+Wa71gKponDTgo/D72O2x5oWC0svZB3iCqJ4ingtyV5qLryERRQz4S1bYaF0AmiXMBXPkEUp+UE/8je5tbMsqSsJttdIxzxYOBFMRy9z8kJuuoNO/qc0dmkMoCup9t7tKzfVc2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784556253; c=relaxed/simple;
	bh=v68rQyf67M4cdo8Cjdo49uXvdGqyQ+lF5cciiGtVKkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r48AU+cJxP2MPhLtb8PAkdnyPXq+0Fo8RkWFbuTurgxUcmrnPTryXsUoP0uo3nn4kv8905dh+nemYSFjSR71wvUr7hmQwZYchQMBeaBj03uO6iAIdc+zYA7SwRvkQ7XYuZVaD72v5DjdPbzpULSRpeDzs9RdxGYcl1V9Dnr6kcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l705GpzQ; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l705GpzQ"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49555a0e68bso8703195e9.2
        for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 07:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784556250; x=1785161050; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9J5yxovoCdxAOMOeUh6Y+dQmCs/UPya27GLpD3HBdBQ=;
        b=l705GpzQQFjoIfThsyhc0kDPZR3FFbem1WG0IfgAo8Ci4d5GQNVKeT9/i+2tR0rdrf
         bFmp7ltNJetsjO4T8soypEQRxYE96nZHO7ej6YaoN6kcm2R3qwp6sdYXSWvatsbprj8z
         S2RurNtiohlgXAD6G7sXn/5mGJ8LZl7ECm5W0/tyBXqO2+t9JTfj940xXA6rqxgCRlbt
         i8VqmGdarBWjfAWue5Zb2vY780XB4ZAES7iUWd/WinmaiU1lqsQfXdnpXKCE4fe9Dhws
         jAVRJTxdccXjHLFSo17/w8B6XCeRWMsaLB7SLpG14EbU1Wd8UZQRrnT9tHcFUmOkapbd
         mIaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784556250; x=1785161050;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9J5yxovoCdxAOMOeUh6Y+dQmCs/UPya27GLpD3HBdBQ=;
        b=QX58YLjXYUyYqdXRwcIs4IJGzjmPSiOPMgPjBwOG97R1U7L56fEIknat2PIDrAiztK
         bJe278Pt19tX/O/yv/+wc7G95lL5uUt4O46SL1SDkswCqDjFFMWShTRELW6/odPlUiLF
         I7q5TZWhodSANDXanspm8Pq5MhWlkOUOLCDyMH4vv8GCCEovOEq7cStRjLtUDpizJ8cV
         aAc/aeaQgiUvG0tX3bpDGRtXG045VLLJqimjo8DJFRvjaGm6XTnBkpWs57aM4D5+LbdD
         X9fa7I0LYkkn1/Bc/Ky6rKq7RdsOxikb/ZuVYmCVaNkxq7eK8turXVD/JA+nkYlCK5m8
         1eKw==
X-Forwarded-Encrypted: i=1; AHgh+RqaRBqbcZdk+YmUi87r3k2BZ7bG+hKGy/0t1E230s3uUenWTjxdba8ZmEB3EHJCIh44sr180JA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxPYkVXB/s4lhVlfV9W8p0YuWMjPRNZRW0ZyfRH4on6Avrd5sLH
	GL5cqtlUr2kNknguK3xIio/ioTayPxCe76RK9hVR/hCkmgDcI1A23H3+Ta5J47qN3A==
X-Gm-Gg: AfdE7cnf95D2fc1XNSMHSR2AozGVeSPNHC2IS7Qy+vkUEYITzJYu1MBTGjq36UsLM7T
	kweRj7cbEh03+gQ5aA4aBZEaWL2EtENDirfTYFlan4sqaLT6nmk8PvunTzhStGFssyStCe/3HtG
	gZBQnpdezo80JOAonU8S7QZYoji7ilFMMz9r0cNH9Vw7D1/hJC+zDET/2X7keqOet3OXYj42C7u
	vP6ukUSe079gopqLHLXzyClrEElulvgJgBcyeYjvZBZb1xREDl+wS2mduzV7jFsI/vQm2LvM5XX
	CjIHN+J+Oq0r77CxJypPbUFDLTwuynPQYqhEZNHHTzXUx95ZGlWOIm/BG8z9LX3fkwXb58QJStv
	41WpeylR5yXrqwP71zfUn855+RLyPlctORyNIq213G8oYd5AW7EWoDtBs40dlWbXwGBVXzVxbns
	hIe7tTVdg7NbiLq1N7lzvAEf4gZCoHuTSFhd3Xn+OQuWW5DZbvX0g=
X-Received: by 2002:a05:600c:1c16:b0:495:5022:71b9 with SMTP id 5b1f17b1804b1-495502272f2mr136915945e9.33.1784556249104;
        Mon, 20 Jul 2026 07:04:09 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954995b78dsm185090025e9.0.2026.07.20.07.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 07:04:08 -0700 (PDT)
Date: Mon, 20 Jul 2026 15:04:03 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kernel-team@android.com, qperret@google.com
Subject: Re: [PATCH v2 18/18] KVM: arm64: Alloc simple_buffer_page using pKVM
 hyp allocator
Message-ID: <al4q05rBGvJzi3Vl@google.com>
References: <20260706175415.2604046-1-vdonnefort@google.com>
 <20260706175415.2604046-19-vdonnefort@google.com>
 <CA+EHjTxRFSW=9fAYvikL2t48ykaiGp7O3Mg6ddXdtFZrmWWaGQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTxRFSW=9fAYvikL2t48ykaiGp7O3Mg6ddXdtFZrmWWaGQ@mail.gmail.com>

On Wed, Jul 15, 2026 at 04:07:05PM +0100, Fuad Tabba wrote:
> On Mon, 6 Jul 2026 at 18:54, Vincent Donnefort <vdonnefort@google.com> wrote:
> 
> ...
> 
> > @@ -193,17 +211,8 @@ static bool hyp_trace_desc_is_valid(struct hyp_trace_desc *desc, size_t desc_siz
> >                 if ((void *)rb_desc + struct_size(rb_desc, page_va, rb_desc->nr_page_va) > desc_end)
> >                         return false;
> >
> > -               /* Overflow bpages backing memory? */
> > -               if (nr_bpages < rb_desc->nr_page_va)
> > -                       return false;
> > -
> > -               if (cpu >= hyp_nr_cpus)
> > -                       return false;
> > -
> >                 if (cpu != rb_desc->cpu)
> >                         return false;
> 
> Sashiko flagged this. Nothing here bounds nr_page_va from below, so
> with nr_page_va == 0 on every CPU the bpage size sums to 0.
> hyp_alloc() still hands back a chunk, but bpages_backing_size is
> stored as 0, so when init_mm() fails on nr_page_va < 3 the free path
> takes its if (!size) return and never frees it. The host can repeat
> it. Would validating nr_page_va >= 3 here work?

simple_ring_buffer_init_mm() already validates nr_page_va. And on error, we do
seem to rollback properly and hyp_free().

So I don't believe there's anything to do here.

> 
> I don't think the rest of Sashiko's note holds: the zero-size path
> succeeds rather than hitting -ENOMEM. And it's only reachable from the
> host kernel, not userspace.
> 
> Cheers,
> /fuad
