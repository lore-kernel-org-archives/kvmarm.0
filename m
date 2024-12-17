Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC7B1E8823
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 13:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734440749; cv=none; b=Bg4pIvylxBO6i7hhg1+BDrENsrRS9btH+PMERbQ/NVzNlwdABN+m2Rw8MNLzDhvum8m1XcVGyyQebuCR5fSeJeb3TepxMf7KXWqha1omnNjkt6s4ddYhrf/sTDJP4StJL32gqy+Sjc3Va2dsRu0iwh+OBHdSua9I+A2igf4MS/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734440749; c=relaxed/simple;
	bh=ESLSBuERl19IWMtBVZAhzvVsC7jbezB5GMfTsOfRYWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lbY4JgKl0egT0AtIpeZgGQS246yWxjDZGK2/5hX6CWisQ13QpUWsxw1kIwR7w8DmbbBS0LaPoDD7SKQbLnEB1IaXwM0GhwP+fRkY3Xoq5bmi45Ueh+H5wsX9uDblqrZbNHe/9GbHsviijIVUwKJmFYvattgrgJIG3v7euxCMARY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CFAJ66RE; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CFAJ66RE"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-aa6aad76beeso736622966b.2
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 05:05:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734440746; x=1735045546; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jFIpSlbWhQWU4BmnuczxZhQrx3hDBfJmwoIXHjm0XOk=;
        b=CFAJ66REjszTEcxbWT9yuzPbKkyyx3/zjIFMNw9Ix4nzS4HCYSyoh42i7A9hX5WHXb
         AutY4Z1aV6P+Lh9+KqPs22OTY+J8oJ7xgMP5v73Y1NG5D/zNIdoEOG2ODmXp6cuHKWTu
         T1KRZ+CMsutYoVAnBOHyH6jGpCAytMHlwwC/lwOn7qZebvCt0iYg+pm9N+IHOaea5mJO
         Q30odmzMlEWRNgFE8hKIIk0AaTsR2H3tBi/H5EO2LsVtVrj02nscVt0mjWaDS4PPqQUJ
         ePPbOGvI7pXBzB8eyRUZutdjsVEz/aIFpYNf7lfngF/+zqu4Tip9TVPHDd0sLKQb4h4I
         mJpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734440746; x=1735045546;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jFIpSlbWhQWU4BmnuczxZhQrx3hDBfJmwoIXHjm0XOk=;
        b=E2yastU+HjVrB4juuiLLC0y8MooZ/H4WPs/LQeUyRcvzagU8imRMccZRVQUGr+aIkH
         GlWszFHw5V3Rg9ALWEhw29wfbMXkNyCuyd6OUdiVu937pS3bqS298FOiJSNUgRyN/H8o
         6gnOLo/QoHc2lTax5GWSOrLYrYUi52quWyvxdavLG9dAbsPQb2T3GHzipd6/LR0+Fek0
         bIkVyYMtbmsE+P2YYNKch1nUg+jolfnpSp6+LuCeXJ+fP/pBcE9wDPUq9fxgC4EDRxdb
         5qyY9euyW7FgiIbFIXunWkh62RVFZOz8n9njDxd2KXbeZF3+W9ZHXpsgmLm38n8rDkEO
         jMDQ==
X-Forwarded-Encrypted: i=1; AJvYcCUeC44IGAPy5NOJa0tPl9JZXBD9UPpkgnU0C+BQhEuAbTi5YyMScjD70nWD5Wicr2o0VMZeyZo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz15CHmMEflgp+Q9ovzYLB31E3Hmm7VBvg+RhIMZLITx/ndfd5/
	QrOS5YoqWl7CZRBySkZnNBDzFsWb4vFxsj8ZGiAFtLQ7pnJ8xu2bUk4OdWbqoQ==
X-Gm-Gg: ASbGncsAc7E/50aDpBwBfzNx69fGK9dpW+pBt+x+YxeyvxUW18YsXpxcLBbVYVOFZNm
	qyl9dMvMExwqSfCrwF4djpkHQJpb7gXnqlyWXrhMVs4GXBF9XYppVYbLdq0IyB6KkhM0H9GjsJT
	LKEFDkTLK7UjAu4OX5K4zqWfY4ESijIFI5bnReo9Is9P+uk+5Szio27lQN7YYPT03dK7T8YCZfx
	OCzgQ80ZvvFTEn2wCIX1Y02P4OWtMTn12wzU15mEmp2JsETdn9221WTaEs03TX3EMmW1teSalow
	kA9la78fc3p0HkY=
X-Google-Smtp-Source: AGHT+IGm64uJtVDjEAURcs9xZJG95uD+8LpWsogmwS7IwX0FntYGVqCsBRC/TY5BflaZ6Q9qsi8S9Q==
X-Received: by 2002:a17:906:6a1a:b0:aab:7461:fbe5 with SMTP id a640c23a62f3a-aab77e9c72cmr1588746566b.45.1734440745515;
        Tue, 17 Dec 2024 05:05:45 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aab96005f89sm446090766b.35.2024.12.17.05.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 05:05:45 -0800 (PST)
Date: Tue, 17 Dec 2024 13:05:41 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/18] KVM: arm64: Non-protected guest stage-2 support
 for pKVM
Message-ID: <Z2F3JZII0gh8iOH2@google.com>
References: <20241216175803.2716565-1-qperret@google.com>
 <CA+EHjTz7=dRz5X-CjjniJgwd87Q4DQbRdXzi0on4C21urYnhOQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTz7=dRz5X-CjjniJgwd87Q4DQbRdXzi0on4C21urYnhOQ@mail.gmail.com>

On Tuesday 17 Dec 2024 at 09:25:52 (+0000), Fuad Tabba wrote:
> On Mon, 16 Dec 2024 at 17:58, Quentin Perret <qperret@google.com> wrote:
> >
> > Hi all,
> >
> > This is the v3 of the series adding support for non-protected guests
> > stage-2 to pKVM. Please refer to v1 for all the context:
> 
> For the series:
> 
> Tested-by: Fuad Tabba <tabba@google.com>

Thank you!
Quentin
