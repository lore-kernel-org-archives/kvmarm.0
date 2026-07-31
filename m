Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CF5376BDE
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 21:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785533730; cv=none; b=bJWCjsYZlMqAV0sBXWsuSd35C0jGmm3ewhxypKU6XcbgSUmrl+x9pIgpLb4EZcShmh5q3JxKtuNekpRq+eysy7I5oWudqjaFthbM+3s2UjuRmXBlKtuDFrqnSVlLajQ31aYtouJ1mojEUG0mCcwdFLTjQ2vC8fOV7XueLHEj0jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785533730; c=relaxed/simple;
	bh=2EqvsjEt5koKNsWYyqZebzmj+8ynedJAEvmViS0Srz0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RtZZG3CFDnTdyeVP4NYNqtP0Q3/W7IvIeW8Hojljr6m8+aU6Geg4LWX1cIQ80k9UNOJt1Eoz9nemMw7fiufARBWFw1xTVUkmqCkbmeyCRDP4x5fPPOGQGtE9yw82KXOQAMEYh45ODgGOGjMvrOrtpy9MQAdlGGRSui9MYgBdhFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fcdh5uXQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fcdh5uXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0B71F0155E
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 21:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785533728;
	bh=K++rx1kgaP2Gvj5Cqx+OBSxkCsmXhtm0mAnimMEoo0o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fcdh5uXQ8J17UNZiJjPZxiCcZj9kCpIZat/7Q1TNleFpevWzca4DIoFmB1cj+uKAu
	 VEKZtL0/TvjR/zs2ZH1OZSo7FiRcASX47S+6roDXIEHVvUSu+/61GQpAI1BE9yiW9e
	 4BYOEHnCjwxErnUzao/3OcAGiYy1PRNOENwhZ+BsAW+Z8dBj1tbT11GvtFAAryiOps
	 CnL64qIRL4V9Bp3cXQkteQ8Zw7dON0SX3SGfBS79wGak/CZDQEHEk1RuUzHUybsZBz
	 IjIha/gxifdk7WpY7qyq47SnYSPGCz3ptYsmSxZYYCfTwYW5nB5GHCpbRCAR/D+sJi
	 b36wZq3p+c9qA==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c1712a04ddaso237911266b.2
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 14:35:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpobgETk0VHVoh5iA0f90BQMeX7yekWx0C4k+kRE8J5KeSeJh2++6kE2zVX2ptAoWghV5lXuG4=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywo0qqZV/ivuh/sT/mcbY/3nGsMz2XIOB+MTelaQ+V/HOliuKOn
	1lGKvF3eDwIFCBSszbtWOl7DA2W8nXGRrH0zUCucm8S8ozRm2AI9xVSgjXHtSBNezpskCdK7HkT
	xZOW9+YUmFbSO1+Mr1qMMyXlFKi7vXDs=
X-Received: by 2002:a17:906:7f84:b0:c12:8664:6aec with SMTP id
 a640c23a62f3a-c1fe826eac5mr42821066b.53.1785533727476; Fri, 31 Jul 2026
 14:35:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260731195612.2697986-1-seanjc@google.com>
In-Reply-To: <20260731195612.2697986-1-seanjc@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 31 Jul 2026 14:35:16 -0700
X-Gmail-Original-Message-ID: <CAO9r8zO-eCz-4Gpa_FUjRKPaDj82PP7et7KON4S5QfhRU2J-Ug@mail.gmail.com>
X-Gm-Features: AUfX_mwe_OJz39TjVH0VtgPbVgoU9MwzP5iyfl-3Rd-uJd2L1ePI9CeEd3Sup4w
Message-ID: <CAO9r8zO-eCz-4Gpa_FUjRKPaDj82PP7et7KON4S5QfhRU2J-Ug@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] KVM: selftests: Add more syscall wrappers, fix hardware_disable_test
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	David Hildenbrand <david@kernel.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 31, 2026 at 12:56=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> Third time's a charm.  Sorry for the spam.
>
> Buried in the middle of this is a fix for the hardware_disable_test where
> it can end up with a runtime of multiple minutes when running a preemptib=
le
> kernels on a large NUMA system.  Turns out my analysis/guess in v1 was wr=
ong;
> the problem isn't direct CPU contention, it's that letting the workers do=
 any
> amount of "real" work on any CPUs leads to pthread_create() slowdowns fro=
m
> the perspective of the caller.

How long does the test take to run with this series?
