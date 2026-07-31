Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF52A2E54B6
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 17:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785518882; cv=none; b=VbsOi3pJM033cAZuC7q4UScBpJjkjdfROsfCcxxDxh2zH8Mery4K19AffEYcQ7duEHKhYUwMLuFSGlz5FlGU3Vn03O/v0oeEs6k8jrvyPUyzU1w981+6BnopuwRjOPtcDCAxe9RyB4ym5ikKNL7QRYjtmTm6Q9VCe1PzrR6WTvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785518882; c=relaxed/simple;
	bh=UDpYe2Tx4XuD5LemyWw//zY5kwL1leOW5OSpqdrWcSQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TDaviShjB8mEgba7vb3q54Y8A44QZvIETq3tqm79Tf/tC9qsGlD0uT4l/km5YOgk9gQ1Hrca+Z5LNyMf61CPbx5MbGzwzJgy29iEjWlRNgvBJMrz72Wvhn1H7LDjVVBL6qzSx+MAOQM26Mx1fs5wKLMlK4PLX8aqA2XFtOP7/ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p6ljfea8; arc=none smtp.client-ip=209.85.215.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p6ljfea8"
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-ca860baea9fso2711306a12.2
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 10:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785518880; x=1786123680; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jIfuZJWx97IVmiAcI0nYTV5I0RoblwpbhFeaam0U4M4=;
        b=p6ljfea84inPxySB8guac3Bmqgpuwhn9gUPWqZwwXRt+oJJV4yLcGIWKB3ylcb3Rb4
         6JYbW7RIgWsDMYQZS31BiJclHXOF/fSX8AE6gvNAG+em3QyamAsPTXYc4bgHqJT6tqSR
         vr4AqHnqd23lRwrR7bWTuBtkiPJkq1fqImYHj0olRVrUcjlZZstJxY0t7A6kSYKzrCKS
         Pqo4zaVhkYOGfoeq++Emtr5A1BYQJytj5SVYcYHqI4MGd/8BwwjNT3Xt77Mm+igBXiar
         hpeI9dRTszc7qcqRi8Fz3cbrlZ7e2XmrSIKbslpg8i8+qKa+CXbSrWxUBRXSKS5U1r1L
         4WBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785518880; x=1786123680;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jIfuZJWx97IVmiAcI0nYTV5I0RoblwpbhFeaam0U4M4=;
        b=GeR3NvQZge70vuhB2fHoSLXyWaB8wFfmqTLvD/8pyKGHfY9En8Up8QlN2+F4GWjJqZ
         ROpsM35wzmrviGAoRu3Oj2HA5Q6T6bZGvt2ECXkF+voZT0KMPnRItqcZDs7MsBnnT5AW
         MIALsiglIeNiPPcI1R9/MOuyPo7IOWEDIJxl9YBoMCktnpR1cQcvTyW4Zw23HE5m+vdq
         uEhU9QYluPpX/r27qitdBHgpy+GvR0I1nE8GWyONJYS2msYLPtHlUcC55AF4Aye3XTwR
         mktblRThwPwBbcg5N68xtG2X2mrVnewYZ+mPHGwilxwS+5RkISmY8iW/4mcNhjJ9m4pV
         w0lg==
X-Forwarded-Encrypted: i=1; AHgh+Ro12w6uO+UuUMiEbnBg5oCmyRQMtipcv7qZLXCsT/veVd19+7jUUlQ7lii8m/ll7rqkLgkCwAo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyttBNlTtVQ6qJSx/9DvsG6LiKUHxy4UkBR7gnXnkNp3krZDejv
	I6vp2dapVyrhdCuqYyDMevM/vTg9w5UHZ+fKt2hf9FlLlTzkfIDgj3V/yIO4bGKprkUfKmEKbMF
	yBqY97g==
X-Received: from pgbq32.prod.google.com ([2002:a63:5c20:0:b0:cbb:c1a9:51f8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:50a:b0:3c3:75ff:95b6
 with SMTP id adf61e73a8af0-3c92a748fd1mr582286637.31.1785518879545; Fri, 31
 Jul 2026 10:27:59 -0700 (PDT)
Date: Fri, 31 Jul 2026 10:27:58 -0700
In-Reply-To: <20260731171540.7B3FF1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731170619.2620845-1-seanjc@google.com> <20260731170619.2620845-7-seanjc@google.com>
 <20260731171540.7B3FF1F00AC4@smtp.kernel.org>
Message-ID: <amzbHqvWFk5-HpQY@google.com>
Subject: Re: [PATCH v2 06/12] KVM: selftests: Affine threads to random CPUs in
 hardware disable test
From: Sean Christopherson <seanjc@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 31, 2026, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] Randomly selected CPUs are not removed from `allowed_cpu_set`, leading to duplicate selections and artificially reduced test concurrency.
> --
> 
> --- Patch [6]: [PATCH v2 06/12] KVM: selftests: Affine threads to random CPUs in hardware disable test ---
> commit 093b65b96e15e7cdd5b611bd7d8556fb88cae6e6
> Author: Sean Christopherson <seanjc@google.com>
> 
> KVM: selftests: Affine threads to random CPUs in hardware disable test
> 
> This patch modifies the hardware disable test to affine worker threads
> to random CPUs instead of hardcoding them to CPUs 0-3. It also honors
> the starting CPU set during this process.
> 
> > diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
> > index d8288147b0a69..bd23c13003707 100644
> > --- a/tools/testing/selftests/kvm/hardware_disable_test.c
> > +++ b/tools/testing/selftests/kvm/hardware_disable_test.c
> > @@ -149,12 +149,15 @@ void wait_for_child_setup(pid_t pid)
> >  
> >  int main(int argc, char **argv)
> >  {
> > +	cpu_set_t allowed_cpu_set;
> >  	u32 i;
> >  	int s, r;
> >  	pid_t pid;
> >  
> > -	for (i = 0; i < VCPU_NUM; i++)
> > -		CPU_SET(i, &threads_cpu_set);
> > +	kvm_sched_getaffinity(0, sizeof(cpu_set_t), &allowed_cpu_set);
> > +
> > +	for (i = 0; i < VCPU_NUM && CPU_COUNT(&allowed_cpu_set); i++)
> > +		CPU_SET(kvm_pick_random_cpu(&allowed_cpu_set), &threads_cpu_set);
> 
> [Severity: Medium]
> Since kvm_pick_random_cpu() doesn't clear the selected CPU from
> allowed_cpu_set, can the same CPU be selected multiple times here?

/facepalm

Remembered to CPU_CLR() the selected cpu in all my fancy version, then forgot to
do so for the simple version.
