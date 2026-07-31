Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C64F44AB99;
	Fri, 31 Jul 2026 17:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785518142; cv=none; b=mwBKN8WlIEOpJt1Bjz9FxqwkF5XSwETT6Tqj6mwdfsNSIMeDR7OFcAs5xNTkYW8BZPtq/BBBSX8UWc7FgxWld92HxCOFUcNWRL/M8TfokJhG43RH2iS8MF9eNEEIxkEgKau5t9SiKdAjjHzW2rb9W5OACFd3ktckE5mG1LlM+e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785518142; c=relaxed/simple;
	bh=OxRvi3BZ5QA9TgHDa8XGL02xaPN2MGD5B5Xyo87p97U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Zh9pKLUNP65QEcFNJUYE234JJYDDwZu7WzCCRdKjDzonVQnpb85xsaRD0cpxn0KzgqF+BojSrTRTn3OKf1XXCZurNSgc9bCYE0+qI0EaMFN0UElREr0/F6MCtv2QXz70ppbVDpGNRLBxfP4FQHz0MXx0BnVY4PGU60pLSev2+W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P3uFZhA7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P3uFZhA7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3FF1F00AC4;
	Fri, 31 Jul 2026 17:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785518140;
	bh=UzfyyKeaFfXOHOc1A3zIbNaYa3Ju5Hh5ybifXfcg3Qk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P3uFZhA7ryXnXNacOXuQX7rQ2OwZUrRZNuHjpCKUm8d7z9W7aNRE+PTHPR35QTn70
	 zR/3qFWjSpNI+kpBYTBjMz0CZzlrnWRrvARPkTE2q41wq+G8l0ZFwaSDHjXuYeLCyV
	 ehpSEh3d5fuSgQ6DwreTTe3LqMw3UpuqLYivX+GVXRRdv49cJLeXQvyTZhJWiSxOVR
	 c90egZgEpChfMNeG61qxtGzo3eKmFwhIukWO1zH0hXr4WArb5spYiOd8CeLnEHkazr
	 bMX3dMzWB+YFU+j3VXWhTKV/GGnq/m4No+e5+NYP1OfJtyA+DSwVgXfSh+0kzGcYGW
	 HA0z2bPdk2uZw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 06/12] KVM: selftests: Affine threads to random CPUs
 in hardware disable test
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
In-Reply-To: <20260731170619.2620845-7-seanjc@google.com>
References: <20260731170619.2620845-1-seanjc@google.com>
 <20260731170619.2620845-7-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 17:15:40 +0000
Message-Id: <20260731171540.7B3FF1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Randomly selected CPUs are not removed from `allowed_cpu_set`, l=
eading to duplicate selections and artificially reduced test concurrency.
--

--- Patch [6]: [PATCH v2 06/12] KVM: selftests: Affine threads to random CP=
Us in hardware disable test ---
commit 093b65b96e15e7cdd5b611bd7d8556fb88cae6e6
Author: Sean Christopherson <seanjc@google.com>

KVM: selftests: Affine threads to random CPUs in hardware disable test

This patch modifies the hardware disable test to affine worker threads
to random CPUs instead of hardcoding them to CPUs 0-3. It also honors
the starting CPU set during this process.

> diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/=
testing/selftests/kvm/hardware_disable_test.c
> index d8288147b0a69..bd23c13003707 100644
> --- a/tools/testing/selftests/kvm/hardware_disable_test.c
> +++ b/tools/testing/selftests/kvm/hardware_disable_test.c
> @@ -149,12 +149,15 @@ void wait_for_child_setup(pid_t pid)
> =20
>  int main(int argc, char **argv)
>  {
> +	cpu_set_t allowed_cpu_set;
>  	u32 i;
>  	int s, r;
>  	pid_t pid;
> =20
> -	for (i =3D 0; i < VCPU_NUM; i++)
> -		CPU_SET(i, &threads_cpu_set);
> +	kvm_sched_getaffinity(0, sizeof(cpu_set_t), &allowed_cpu_set);
> +
> +	for (i =3D 0; i < VCPU_NUM && CPU_COUNT(&allowed_cpu_set); i++)
> +		CPU_SET(kvm_pick_random_cpu(&allowed_cpu_set), &threads_cpu_set);

[Severity: Medium]
Since kvm_pick_random_cpu() doesn't clear the selected CPU from
allowed_cpu_set, can the same CPU be selected multiple times here?

Because the selected CPU is not cleared (for example, with CPU_CLR),
threads_cpu_set could end up with fewer than VCPU_NUM unique CPUs. This
might artificially reduce the test's concurrency.

Additionally, the loop condition checks CPU_COUNT(&allowed_cpu_set), but
since allowed_cpu_set is never modified inside the loop, this count
will remain constant. Was there an intention to remove the chosen CPU
from allowed_cpu_set in each iteration?

>  	sem =3D sem_open("vm_sem", O_CREAT | O_EXCL, 0644, 0);
>  	sem_unlink("vm_sem");

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731170619.2620=
845-1-seanjc@google.com?part=3D6
