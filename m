Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0521F099C;
	Sat, 13 Jun 2026 00:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781310525; cv=none; b=rVyYq9rJKh/cCWYNFdGYLwaGcyuzd6vUPbLi8ykCDNNHd3ELckpEGx4Pc+PBM+73yHY0gMfYy0xl6cB1roUHXB19CKpBU2lZrFbNkDXeiOdrZKgIieICPmOUMU3iLc4qMhwUwuqr707Ep0ZpEJNV/ati2dvz477m+pTM2uL8IPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781310525; c=relaxed/simple;
	bh=p4XRGmByZ6Qw+8oDxbILVIWe6OHFhI8PiQOfPYpxTkE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ez3VFKuzNwF0k9i+7lgtxHRVuvEVNRZmL4c6Xt6iWtk3iPu9KQcSKUdvyZMNec1nbW+NfhKmzkTheMSp7WhA+1XugUZHETvWuaY/rJnv+JmJAkprMRkHW7WYe8GX3ppKj84WinjKjj6bzwblHzYRbmdrn+SZBKEYUuOvwzncc7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iD0eqiBM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iD0eqiBM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279141F000E9;
	Sat, 13 Jun 2026 00:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781310523;
	bh=ib5gzdDeA+tt3kEcAMepTdKfoO9lyDezaBPOz1KqiOk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iD0eqiBMNfOO3rWV1z76qTwJ2fEwIXOjLDWz/Nl/Z8ewH1NP6LVEdcY++1jBzmNZK
	 HSG31DfJ6G+NE8JonpRGvF7YNTysuY3oc+l8AtYCK1Jw6EfIjoB81wudPcEjMy+tFu
	 mkh/KhM3vYEygBw3eJuG7jl2f6C6Ev70b3eUxgngrcJoexvwM548QTffBABAK9BEg5
	 WnAQnrNCyHhFFRhUvzh9J/UQhdsH13jsIO1k6196Pun7cTkZjKFG3R5kkylNLkj0ia
	 xNew/Kd8NSc94O9jzCNsYr5POzftDCYLJdNa8Dq7gJn/X2Rs2/y+i7gzKIdk1DOFU3
	 gCpC1o+T23NDg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 08/20] KVM: selftests: Add helper to get host IRQ
 from device MSI-X for IRQ bypass test
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260613002031.745413-9-seanjc@google.com>
References: <20260613002031.745413-9-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 13 Jun 2026 00:28:42 +0000
Message-Id: <20260613002843.279141F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Reading /proc/interrupts with a fixed 4096-byte buffer truncates=
 lines on large machines, leading to incorrect IRQ numbers or test crashes.
--

commit 399b5fbbf0a019bffe136ff08d75cf31f2c2655f
Author: David Matlack <dmatlack@google.com>

KVM: selftests: Add helper to get host IRQ from device MSI-X for IRQ bypass=
 test

This commit introduces proc_util.c and vfio_msix_to_host_irq() to parse
/proc/interrupts and retrieve the host Linux IRQ for a given VFIO device BDF
and MSI-X vector. The helper is intended to be used by the eventfd IRQ test.

[ ... ]
> diff --git a/tools/testing/selftests/kvm/lib/proc_util.c b/tools/testing/=
selftests/kvm/lib/proc_util.c
> new file mode 100644
> index 0000000000000..84d30f055a0a9
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/proc_util.c
[ ... ]
> +unsigned int vfio_msix_to_host_irq(const char *device_bdf, int msix)
> +{
> +	char search_string[64];
> +	char line[4096];
> +	int irq =3D -1;
> +	FILE *fp;
> +
> +	fp =3D open_proc_interrupts();
> +
> +	snprintf(search_string, sizeof(search_string), "vfio-msix[%d]", msix);
> +
> +	while (fgets(line, sizeof(line), fp)) {
> +		if (strstr(line, device_bdf) && strstr(line, search_string)) {
> +			TEST_ASSERT_EQ(1, sscanf(line, "%d:", &irq));

[Severity: Medium]
Does this 4096-byte buffer accommodate lines from /proc/interrupts on hosts
with a large number of CPUs?

If a host has enough CPUs to push a single line beyond 4096 bytes, fgets()
will split the line across multiple reads.

If the target device strings happen to fall into a subsequent chunk, could
sscanf() mistakenly parse a CPU interrupt count as the host IRQ, or fail
entirely and trigger the assert?

> +			break;
> +		}
> +	}
> +
> +	fclose(fp);
> +
> +	TEST_ASSERT(irq !=3D -1, "Failed to locate IRQ for %s %s", device_bdf,
> +		    search_string);
> +	return (unsigned int)irq;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260613002031.7454=
13-1-seanjc@google.com?part=3D8
