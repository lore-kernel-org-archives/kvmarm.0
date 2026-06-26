Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6223B27CD;
	Fri, 26 Jun 2026 21:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782510125; cv=none; b=FqMsO31bvwfTZleeyIkb7swmbIG55+sYmbXKHrCrwLhZv+++kML+jvNYiohbWdKnIvZ+pt8Or+VKbP+IySeYDUcBXiMDkm0qkS6BUqm3upLSyWjpwQj+GB66L6iETuEjHKGfd4ZYN2Dy1qbJ6VcnqiJTHMjosLfAoBpF9MhaoFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782510125; c=relaxed/simple;
	bh=gaICnOXeEj9JMSZMFokM9Oe2hECCyowEvIQ3nPKqJgg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kNLTLr2SdiPoYdRv9IjB99YSH5WbE/e/UlYm/gc05Mbr/X07WPS5bdSAX/rHXBwXh41LpTH1c7WsvQCQEQi9SvhgfA9BW5ngX6BnAxhlq/ONVIYmfRYT8T5SGwtOPDFNCrlWM+jrIEmCu0Il4xoEbKKz/QujO83vSvBh2/rNreQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HwhAatFT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HwhAatFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4F51F000E9;
	Fri, 26 Jun 2026 21:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782510124;
	bh=Xnpjlqk5HXJKq4J1suxdS53iM6NAZ5D3T+1I90MerKU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HwhAatFTeqyblEnZLsfEWjJcIyVbMMX6tfrzgSNSYCBgpXpMcAdMLkWa0AwEkuiOg
	 lRZITA4mb9K+38jtSbN4JVXFWCRBRB+50pmnm5oCl6IapCYZc5hvZ2GMng8qnat0s4
	 KmxdNkV/UnKzj2wUvRGuayF9F1RsJeRFDRn2dWe+PuY0rnMvPy3rZzLYGq+EvmUIud
	 gYbVRJIRzyDZfoN8UUEkMrlJrovO56OF6c1KGLRhcf06w7Bn0fQlqiEnsZWBRKgNzT
	 ORbH5nZ7/gxi8n+X9daEK+8GCdEt7Qxfs6bVtIjuKDRjb2b68MBizm8lx0kzAqiPNx
	 WPECZtakDx+4w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 08/20] KVM: selftests: Add helper to get host IRQ
 from device MSI-X for IRQ bypass test
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260626213534.3866178-9-seanjc@google.com>
References: <20260626213534.3866178-1-seanjc@google.com>
 <20260626213534.3866178-9-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 21:42:03 +0000
Message-Id: <20260626214203.CD4F51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The 4096-byte buffer used to read `/proc/interrupts` is too smal=
l for systems with many CPUs, causing line truncation and leading to either=
 deterministic test crashes or silent parsing of incorrect IRQ numbers.
--

commit 87caa5d203166722732c2c1909ec869049e95fe7
Author: David Matlack <dmatlack@google.com>

KVM: selftests: Add helper to get host IRQ from device MSI-X for IRQ bypass=
 test

This commit introduces proc_util.c and adds vfio_msix_to_host_irq() to
parse /proc/interrupts and get the host Linux IRQ for a given VFIO device
BDF and MSI-X vector.

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
Will this 4096-byte buffer truncate lines on systems with many CPUs?

When /proc/interrupts is read on a host with a large number of CPUs
(e.g., >360 CPUs), the per-CPU interrupt counts can cause the line to exceed
the fixed 4096-byte limit, causing fgets() to split the line into multiple
chunks.

If the final chunk contains the device strings (device_bdf and search_strin=
g)
but not the original IRQ number at the start of the line, sscanf() could
evaluate incorrectly.

If the trailing chunk begins with a CPU count, sscanf(line, "%d:", &irq)
would extract the count, ignore the missing colon, return 1, and silently
assign the wrong IRQ.

If the chunk starts with non-numeric text, sscanf() returns 0, failing
TEST_ASSERT_EQ() and aborting the test.

Does this regression require a larger fixed buffer or dynamic allocation to
handle systems with higher CPU counts?

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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626213534.3866=
178-1-seanjc@google.com?part=3D8
