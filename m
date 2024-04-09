Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757BC158D8C
	for <kvmarm@lists.linux.dev>; Tue,  9 Apr 2024 22:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712703519; cv=none; b=RBEZOUmD7qNphdXBsWXF6qi+hBmOn08pBdesJ74HrC75fnUWYyNDTCmYdWoo9MuCrOCf/CZN5cNEZbfaudXlTY56IC96bCb/cUMx8sLSmv9d9sZtQZ0MVeEiMg0TVzLVu64ObCWpuQ4ODw+8mAx1UJv10CzjB57wnOQ3LbjclKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712703519; c=relaxed/simple;
	bh=C4UUEPXQ7aNiC2MpIyrA52CI1Xak5d78Q0u4LEWdxtU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OFIB09pg2WHrmJHgzdmc/hga41+AHoluQgmx2Zm8pUnnylgKriaLj9j2NaUs31793Icn8ToxnyGu/ALFifK4OQg8vhX1x6H0EKr1xnh2+ZgcwFzWjeGyd433tTw4NoNiCFKPMtHr3dmTWxYaoMN99RVgS8Jy4An2p23WArVB7Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h/42kKvz; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h/42kKvz"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-617bd0cf61fso97790447b3.3
        for <kvmarm@lists.linux.dev>; Tue, 09 Apr 2024 15:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712703517; x=1713308317; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y6Z88aYJTzgs0pbUWWKLdnj4AYHEigi0XdL5G85Xxlc=;
        b=h/42kKvzg2pP6NEeesHVsrFKLFXE4YHy/CQEDPqr7qn/UdLT6pNZsMvpYjZfTqjLJ+
         N9SvhCz0FOBGsmKykvag78kj2kFTmt402pOXRQqFYCPK8zE1RtyK0IwV3npPEPuSEfcb
         NNlCV9OdYNnUC9ZqZUZhDgZn5ETFdp3twpODcEXCtfeabW3n8xoMNdYsyEgCxCEezgbE
         zHHfM6HVubf1FQmYUfOVJ8yBJzG8fh6wRioRiCEWjb//CkOXtH6rdw21/dxU8IlsWiFZ
         jthe2BT9d8uFu98Yu6ublgxyVY3bO+kgwZjeGSzBM4kscM68XkfFFIRGo1L87oy/xrS3
         WnjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712703517; x=1713308317;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y6Z88aYJTzgs0pbUWWKLdnj4AYHEigi0XdL5G85Xxlc=;
        b=liI4aFRLCAom3I4NXsXV/ezo1U0f7bMXILOkSlnwvfrY5fr+REur/lKQF98gRapjjn
         kT95yHq3ouq0rapFj43rM3LXJax+oFQeuHB3haMso6+nlDO8mGsBRIn/AHuoV/uKhQC8
         ykILzyTWYv4nL4H08gKxqxpAXw1qZu0ARSvyCTcy2pXLYfUq85o9T6CJhgyjw+JWr1s/
         taT0lVIb7+ZyK7V0damskJfXAWIhC4yefsQrMQrThY1zw5jIjs5iqmx8yvbFivwMeJt8
         xdrcD3snTrW/wK4YJ3cxQVmXjhwmOfsfLTV2yTp1fYt6s/gFYik4KbBLOmHefmR79qyk
         QXYg==
X-Forwarded-Encrypted: i=1; AJvYcCU+HtabCM4VCZcfdKHDSBncPE3Ac/GqWTH1ZLG7tGJsLQBxa/G/4Mbo4VHhqRU6W0csCMXAyShp7LGUfGUWL8MulyXW9wXm
X-Gm-Message-State: AOJu0YzE99ewu4W5UaAmBsOvoOmVkOd3AMDLQ0jvBINnOUis50jGtFUT
	YO8X5h9nS91C7MeoXuvYgk+u18N86LUtjEc6JK+Tz7YS9LNrjqKoKc2vs5mDYypuVBXnZZ7wWvq
	tzg==
X-Google-Smtp-Source: AGHT+IGB7SGhpeqD/kjhTPt66yolVDX+BiT9lMP/+KM/dDzWT/nT5YV37XYXL4pSK7SGftosV6zkbKOS5uo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4e50:0:b0:615:1579:8660 with SMTP id
 c77-20020a814e50000000b0061515798660mr263035ywb.7.1712703517472; Tue, 09 Apr
 2024 15:58:37 -0700 (PDT)
Date: Tue, 9 Apr 2024 15:58:35 -0700
In-Reply-To: <20240215235405.368539-12-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com> <20240215235405.368539-12-amoorthy@google.com>
Message-ID: <ZhXIG6uISrC77BQ2@google.com>
Subject: Re: [PATCH v7 11/14] KVM: selftests: Allow many vCPUs and reader
 threads per UFFD in demand paging test
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, maz@kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, robert.hoo.linux@gmail.com, jthoughton@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 15, 2024, Anish Moorthy wrote:
> @@ -167,19 +187,30 @@ struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
>  void uffd_stop_demand_paging(struct uffd_desc *uffd)
>  {
>  	char c = 0;
> -	int ret;
> +	int i, ret;
>  
> -	ret = write(uffd->pipefds[1], &c, 1);
> -	TEST_ASSERT(ret == 1, "Unable to write to pipefd");
> +	for (i = 0; i < uffd->num_readers; ++i) {
> +		ret = write(uffd->pipefds[i], &c, 1);
> +		TEST_ASSERT(
> +			ret == 1, "Unable to write to pipefd %i for uffd_desc %p", i, uffd);

More coding style oddities.

And storing the return code in "ret" is unnecessary, and arguably makes it more
difficult to debug failures by not capturing the failing command in the assert
message.

> +	}
>  
> -	ret = pthread_join(uffd->thread, NULL);
> -	TEST_ASSERT(ret == 0, "Pthread_join failed.");
> +	for (i = 0; i < uffd->num_readers; ++i) {
> +		ret = pthread_join(uffd->readers[i], NULL);
> +		TEST_ASSERT(
> +			ret == 0, "Pthread_join failed on reader %i for uffd_desc %p", i, uffd);

Preferred kernel style is "!ret", not "ret == 0".

Putting it all together:

	int i;

	for (i = 0; i < uffd->num_readers; ++i)
		TEST_ASSERT(write(uffd->pipefds[i], &c, 1) == 1,
			    "Unable to write to pipefd %i for uffd_desc %p", i, uffd);

	for (i = 0; i < uffd->num_readers; ++i)
		TEST_ASSERT(!pthread_join(uffd->readers[i], NULL),
			    "Pthread_join failed on reader %i for uffd_desc %p", i, uffd);
