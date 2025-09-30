Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D172C3252
	for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 22:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759271036; cv=none; b=p0m6D4cO669OiilvMjSFRlTzx8Bw7sm11qL2bDjcbgeDW4mWAIxuhnhFBBOTboICuP/k5kR2l2XgJcMFYGXJPfV7ZiAHalfeLv9gTTEb6dpCYI6g4Z6IlKcBkFDp+1hWw4lirE9gKyaqTYW/q91+lvZvXrgumHKmgvltUgjYMQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759271036; c=relaxed/simple;
	bh=akVWlDti6Yox1LgORdnkES1etQivgEHJY1Xts9mvRoA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=avil2pceD1UYL5JBMskkXtsjnLBK4k2u25puwfHL5uAa6zWCtlSKCiBcjF+xNhwZHt2Kysg7iuIJV+u3BbviZY5vEcg16U2y/g7MaIaffnU7J682C41geqTr5iRnDWA3AzjoR0//4Saf2ew39VVfPNPTfuQlXf3FUG7JdtFtvUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j6ncd7jK; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j6ncd7jK"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-27eeafd4882so84325ad.0
        for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 15:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759271034; x=1759875834; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OovWlEA9+Pzbq4UuSlKiI00VjEkZNQJKGvfeEXc2tY4=;
        b=j6ncd7jKHNlwH0Xqu4jgadRxsa8P+9k1tfsF8KsEopyCKnuiqizR4WHfH2bE0lQydU
         SCFv6jUxemm7Q/HnJ0Rt7lMOULx5Ib5pxQXC3iNmHHNeLSBWEI5J+2nKeR8+/SXrIXK8
         KGeBwbw7zU0yzZ89gGkVX0NJ0otsTYg7WjtAOEaQS+QkEJxMbPkF8aWMdSFvxEhaGifi
         us7DNaBHl83MlwODNFcXVaVAarFgF/Uv9umpbUz/tO8RS0r/OMCN0pZ4vP3hcFvLghEK
         BO7u7LheTeopvsr45swEsrxlOqjpggtO25q+RDq0pVXNr8zQrZF/biY9PlJOmDwL1UZF
         EJxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759271034; x=1759875834;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OovWlEA9+Pzbq4UuSlKiI00VjEkZNQJKGvfeEXc2tY4=;
        b=Sf1BJB713EGETk1SpdMXveIhg5K3bVlV7gwnuVeXZbHyTEkAz9mbI8Dr9qDXNWBZEg
         QxCcWXK3CmjPHeSQtgNrH1kv+8wfGVticVsN2qs8ZUrrF6lfhbNPFShKqcf+thGeylcs
         V+P1uIl3ed12R15rzfwJyFaTBXlKDg7VhCtj5HgbF7FZNWsVafKBwkTlVECwZQmlQP/z
         nTf0DGeXBmHJ76G9uqI/OH9YhUV84D3CpGYeagaoy59O5GhtbSOy998T7Ts+roxAQPrI
         ZX9HwD5SXMvlETKBB7z7MirrK5Ez0XC/CcC+0jQualNZGaU9xWyVyqIrWa/J62mcJc3/
         RHMw==
X-Forwarded-Encrypted: i=1; AJvYcCWZjvsxiFHL673cN/0bgWpY2hGalDG2ZpQdTnbFKIUNwzZqdcrZ/SOZKio9iv9RyHlCPn7vhIc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxXXj7Jrl4vG31X2rIa3X6TE6FnmPGS1M0j4CNVRQdXZ+tTgkgD
	0FLfT6NFVXdbTVBgjmReqHRGPoJGp947YCedVQyxNpvSwXov7SeMxnMEYjwOCE+aRA==
X-Gm-Gg: ASbGncv9iIRvcedl++I5nVTRNMNaT/sgWQWhBTie8NQUASKvpIZmDT8TfFeHCIFVuVN
	GbtnvJXOXrfpyYb24x856UIE2T+9wqcdXeRqhjlWSmR7hxWjyhoTbdoqEp+ZsIF6n8DPsPuUL70
	KpYcw+2+UcOaUvFTyZOXxZDftLMlYSkaAEJde7ERp3H9oeWOLIapCDp9jDKbnEiQvVO/Ce0ZK8m
	ZE/jq+7QZ74drGM694i6WD1YLaaKVk3INxi8gFvsIElNHJyXSzSGIbw6tIu0FM4cCobsDaiAB9e
	f39UO8X+AReujfw0//WUa6kinY9uAdOxhuY8ncsmK3tUF8p19GA864tbKdZbnGtcNupePkdr3Ln
	eRJqD4Yu+q02INMDiClEM3I3d5ea5n14FbM38XDdurLkiBk4NPjUr/Wrl9LLzaIqKzjksgMeUW9
	Y3UGeQNFstRD316MiBtFdfyw==
X-Google-Smtp-Source: AGHT+IG7yXqqtZNgHXq2ux/pq6R5lOByc3Up0+c+fpGZ9ajcwT8arb5aAkRLhIVwYDowJVib6njbyQ==
X-Received: by 2002:a17:903:1b67:b0:274:506d:7fea with SMTP id d9443c01a7336-28e8127b0c3mr707745ad.5.1759271033336;
        Tue, 30 Sep 2025 15:23:53 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed6ab67a9sm167075335ad.131.2025.09.30.15.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 15:23:52 -0700 (PDT)
Date: Tue, 30 Sep 2025 15:23:48 -0700
From: Vipin Sharma <vipinsh@google.com>
To: seanjc@google.com
Cc: pbonzini@redhat.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com,
	imbrenda@linux.ibm.com, anup@brainfault.org, atish.patra@linux.dev,
	zhaotianrui@loongson.cn, maobibo@loongson.cn, chenhuacai@kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, ajones@ventanamicro.com,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v3 1/9] KVM: selftest: Create KVM selftest runner
Message-ID: <20250930222348.GA16152.vipinsh@google.com>
References: <20250930163635.4035866-1-vipinsh@google.com>
 <20250930163635.4035866-2-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250930163635.4035866-2-vipinsh@google.com>

On 2025-09-30 09:36:27, Vipin Sharma wrote:
> diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
> new file mode 100644
> index 000000000000..8d1a78450e41
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/runner/__main__.py
> +def main():
> +    args = cli()
> +    setup_logging()
> +    testcases = fetch_testcases(args)
> +    return TestRunner(testcases).start()
> +
> +
> +if __name__ == "__main__":
> +    sys.exit(main())

Sean, as discussed offline, following diff adds a minimum python version
check. Runner can run on python 3.6, it might go lower but I haven't checked.
Linux kernel minimum requirement for python is 3.9
(Documentation/process/changes.rst)

diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
index 8d1a78450e41..db87f426331d 100644
--- a/tools/testing/selftests/kvm/runner/__main__.py
+++ b/tools/testing/selftests/kvm/runner/__main__.py
@@ -91,4 +91,9 @@ def main():


 if __name__ == "__main__":
+    PYTHON_VERSION = (3, 6)
+    if sys.version_info < PYTHON_VERSION:
+        print(f"Minimum required python version {PYTHON_VERSION}, found {sys.version}")
+        sys.exit(1)
+
     sys.exit(main())
