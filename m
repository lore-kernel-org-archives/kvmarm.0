Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09242144D0A
	for <kvmarm@lists.linux.dev>; Mon,  2 Sep 2024 05:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725255418; cv=none; b=cTp25XUgALwhk/4Xkre5yi8DaE3BVDXVVhUqBvR03cKCJTeUtfEruOP0PuIICUo7RbQ6E0cxi5DIwQKc/DygvMv95TE46Y57h8QivbQhP/WpDVaTBTjM4SC1E5LRjXOlK0gK+bKvXTFsjibL0SP5AXnag+6QM1mgI4gSpsIYn6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725255418; c=relaxed/simple;
	bh=vyexIiq0G3KdAGHxQw2FFAbj2lEAiY2GbjMYb6gvJLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EsAdMbBGj1oB9O5WF8qmRXvkc41P3WOPNpYCCbC8n7NmzKNsbrW5G8tg3HGz7VjZT4tjeOYfpKalCNJBaDLaqGYKa/3SWpipIcflTlVd6th4jC4F0gw5fHiRHCBI5L97/udjBQ3sWXqGhLMJdfvOkwoXFmDpy+t0ePtV7ha8ziM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bzGWc2eb; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bzGWc2eb"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-427fc9834deso54875e9.0
        for <kvmarm@lists.linux.dev>; Sun, 01 Sep 2024 22:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725255415; x=1725860215; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MQ7nhItI8VmPcJbkkl0nLAZengIZ/zDRojcMk7WM8B8=;
        b=bzGWc2ebRD2Nji6kcN1Gcx5Lw+sQgEXAs8CjKGLH5dmhp3C0tdNLHk/c8CqSzSSwB1
         GMHQ95hejfHOcKfzIFNeLQYzxpCNeAK0VdApwQnyE4F65rBjUFRw19/c/Gy+eAqacL3m
         aLWp78wH6vFgdRKmnpDJ8piXi0AU+kRXYEqa8pBU/uwqhk7MCnSqfnU/yrBMIHw5V87j
         uS6iKGrzM4F57Hk+s200xPUW/w0PKOY2j2zZ1IsfzW3BYnkahX7IJuFfo8GLRXLyFg7Y
         z1D2mTrHEV36uXravCPL7iclT6Z2DkkXPNyVZO7N6LBbYqcZ5Kxya+hcV9wtIl5tBfuZ
         YCxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725255415; x=1725860215;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MQ7nhItI8VmPcJbkkl0nLAZengIZ/zDRojcMk7WM8B8=;
        b=N8odN7MjQ/nhJIMBRplTOKtQwDUhQ1YQkn7tsYnsREDiXUn8iiKKdcg0TQOMmnhlen
         oqQ8TV3t464EyRqNm/xFlZnPeh8rur8Vgzb5RgVQ2Y+hMPhH9WnofGKXLMxggcTK0I7z
         2eQKbY2H7SmiJaSvZkkYMuHPB3JTaKMrGH4uhfujuE45cC3Iq05f6JS0B7ttTyOrC8On
         lfuCalsf2600OAXi0eAWZpc+HgVMBB7/63txYKCx/39H9RKZnyu8NgIzVyOisCk/aR9Z
         Pgx/C8XJoRTW1PEtnYhjqkO9SVrRY8XT9BwedT4y8oYuZrxhCEpSZMTHQ+kq5e7CU9LU
         7hZg==
X-Forwarded-Encrypted: i=1; AJvYcCUOdfu39ksO166l5xqQOacaho/GWoHl7jCPuEtUiiRY87VKsKN3scIN22DVLOjKHj/yKoNKVeE=@lists.linux.dev
X-Gm-Message-State: AOJu0YylcOYfMO0BlJ0Kg6CHqS9q2nW3NE0/7YE1bOHcdF4MYdqz5Yul
	ZaNsf9GmykLV2MQw//nJUEP4Bv5s4IlAskKaw2APm5+Fei9jd3MMm3iM22IGJA==
X-Google-Smtp-Source: AGHT+IGH0lniufb3F4A3bPXzpfW2OpZ/dm4ZIb2y+w4AUpvlVhKTQmc4hKWVFLY4JC77+3GFg8WYZA==
X-Received: by 2002:a05:600c:c15:b0:426:68ce:c97a with SMTP id 5b1f17b1804b1-42c787718b8mr1641265e9.7.1725255415043;
        Sun, 01 Sep 2024 22:36:55 -0700 (PDT)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42c846d2fdesm11837575e9.22.2024.09.01.22.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Sep 2024 22:36:54 -0700 (PDT)
Date: Mon, 2 Sep 2024 05:36:53 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: akpm@linux-foundation.org, alexghiti@rivosinc.com, ankita@nvidia.com,
	ardb@kernel.org, catalin.marinas@arm.com,
	christophe.leroy@csgroup.eu, james.morse@arm.com,
	vdonnefort@google.com, mark.rutland@arm.com, oliver.upton@linux.dev,
	rananta@google.com, ryan.roberts@arm.com, shahuang@redhat.com,
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v9 2/5] arm64: ptdump: Expose the attribute parsing
 functionality
Message-ID: <ZtVO9VDe-26jQFUK@google.com>
References: <20240827084549.45731-1-sebastianene@google.com>
 <20240827084549.45731-3-sebastianene@google.com>
 <868qwew5xn.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <868qwew5xn.wl-maz@kernel.org>

On Fri, Aug 30, 2024 at 01:28:36PM +0100, Marc Zyngier wrote:
> On Tue, 27 Aug 2024 09:45:45 +0100,
> Sebastian Ene <sebastianene@google.com> wrote:
> > 
> > Reuse the descriptor parsing functionality to keep the same output format
> > as the original ptdump code.

Hello Mark,

> 
> This sentence seems either out of place or missing something, because
> this change it not reusing anything...
> 
> > In order for this to happen, move the state
> > tracking objects into a common header.
> 
> ... but instead doing this ^^^.
> 
> I propose to rewrite the commit message as:
> 
> "Adding a new page-table dumper for stage-2 requires parsing the page
> tables, and reusing the descriptor parsing functionality would help
> keeping the same output format as the original ptdump code.
> 
> In order for this to happen, move the state tracking object
> definitions into a common header."

Thanks for the feedback, I think the re-wording works much better and
I'll make use of it.

> 
> Shout if you object to it!
> 
> Thanks,
> 
> 	M.
>

Seb

> -- 
> Without deviation from the norm, progress is not possible.
