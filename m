Received: from mta0.migadu.com (out-52.mta0.migadu.com [91.218.175.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7225445C6E0
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 13:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789132039; cv=none; b=C8PKJF5LmsF+3485kI0hbZ+e/aVPB5UUHY3eDSFNzKLwbcaHfOQuZ1OpcW60MUzDfky8iBcJe3/i0mHFhr8CYPv0W4WKZ4nmxgRDcY0EK6RVh5D5w/hAmcchrGewsbnvOOcA7EXfDBNKlsxXVJ3kjUfL5mQOfphOY4NSwSaEKLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789132039; c=relaxed/simple;
	bh=8pvJVApeDyZ7aiv6BhbctxA5gKGIAQr+fiE6OB4oxLk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=snSvjboQW/d7+hvAw3PbyTElv2seWn4/7HREPE1rYdFgEk14k4xLOciglvRYFjAt3AizlCGXhDQI4uXziskucWPZaUcoV4M4AAa83mljF1JMjRQpObgjRrVr2iyKW8K37XhO+DWFlzA2mCzMJQgycbEgqGSCFp+GcD48VOOFZDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DhtNHdsn; arc=none smtp.client-ip=91.218.175.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DhtNHdsn"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=8pvJVApeDyZ7aiv6BhbctxA5gKGIAQr+fiE6OB4oxLk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789132035; v=1; x=1789736835;
 b=DhtNHdsnFmBZLwhG6l2/LpNCkvgjzQNGKlfqvPO+3X6oU6aNunej1krTNMxyLgYP+lGryafI
 Ed/r1XWIipj9ZqGe7LS8epEXZ8/fktjBSHVFdCDMZ4syK6hbedfUa76dkUEiC5BzJvBqYjr4tDK
 uZFtz/AUxoZZDOO/HR5T1zQs=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 5d631c7e176f18da;
	Fri, 11 Sep 2026 13:07:15 +0000
X-Mizu-Trace-ID: 5d631c7e176f18da
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384c4so4684e87.1
        for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 06:07:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByM96jS+5Zb23aHwXtdH8nbTm7lBXun1oSn1KRDbvjgGK83wITl77HI40qgo4CvgGpM7P/lxds=@lists.linux.dev
X-Gm-Message-State: AFuF++n9tlV9JUTS7aYlAkzYG0RkfD/KI1UjPUa7GjrD8YfJBmYnPhHz
	V8fbvoLiy7NjDX2MovBEjimmFlP7UZ+s9lCNUvVxr7CclRxT6o+8VZ8uSUveMUr/Ks5P32RMuGO
	soXpvS6cfvlOvPbhK6+TjLeaRiImlfoNqo2EhlYFI
X-Received: by 2002:a05:6512:2352:b0:5a4:ec:53d9 with SMTP id
 2adb3069b0e04-5b8a0e9870dmr120141e87.1.1789132033997; Fri, 11 Sep 2026
 06:07:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260807164322.2970811-2-sebastianene@google.com> <20260807164322.2970811-6-sebastianene@google.com>
In-Reply-To: <20260807164322.2970811-6-sebastianene@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 11 Sep 2026 14:06:37 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxjF3bFyGPdZTjG2eaSGDn8qgkMn6mnpvR4DpNdmTo2hA@mail.gmail.com>
X-Gm-Features: AcwNN1VrR2kYv2q8ZGCNc3rU7zWSpDHiv9N7fjGK0s-HcxCvjzx3fnURhDkVi2o
Message-ID: <CA+EHjTxjF3bFyGPdZTjG2eaSGDn8qgkMn6mnpvR4DpNdmTo2hA@mail.gmail.com>
Subject: Re: [PATCH v2 04/13] KVM: Parse the device tree and register the ITS
 region with pKVM
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, mark.rutland@arm.com, 
	maz@kernel.org, oupton@kernel.org, rananta@google.com, 
	Sascha.Bischoff@arm.com, suzuki.poulose@arm.com, will@kernel.org, 
	kvmarm@lists.linux.dev, android-kvm@google.com, bgrzesik@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	nathan@kernel.org, perlarsen@google.com, seiden@linux.ibm.com, 
	smostafa@google.com, tglx@kernel.org, vdonnefort@google.com, 
	vladimir.murzin@arm.com, yuzenghui@huawei.com, zenghui.yu@linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi Seb,

On Fri, 7 Aug 2026 at 17:43, Sebastian Ene <sebastianene@google.com> wrote:
...
> +static int __init register_its_emulated_region(void)
> +{
> +       struct device_node *np;
> +       struct resource res;
> +       int i = 0;
> +       int ret;
> +
> +       for_each_compatible_node(np, NULL, "arm,gic-v3-its") {
> +               ret = of_address_to_resource(np, 0, &res);
> +               if (ret)
> +                       goto out_fail;

its_of_probe() also requires of_device_is_available() and
msi-controller, and its_init() goes to its_acpi_probe() when the
fwnode isn't an OF node.

So a disabled node has its region taken from the host here, and on
ACPI nothing matches at all: num_protected_reg stays 0, this returns
0, and pKVM finalises with the ITS unmediated. The two DT checks are
plain property queries, so they work this early. What's the intent for
ACPI?

> +
> +               if (i >= PKVM_PROTECTED_REGS_NUM) {
> +                       kvm_err("Out of protected region slots\n");
> +                       ret = -ENOSPC;
> +                       goto out_fail;
> +               }

Tested after of_address_to_resource(), so a bad resource on the ninth
node comes back as that error rather than -ENOSPC. Could the bound
come first?

> +               /*
> +                * Note: don't unmap the entire animal from the host because devices need
> +                * to be able to access GITS_TRANSLATER to raise MSIs. If the
> +                * page where GITS_TRANSLATER is given to HYP, devices won't be
> +                * able to map it in their IOMMU when the IOMMU is managed by
> +                * pKVM.
> +                */
> +               kvm_nvhe_sym(pkvm_protected_regs)[i].pfn = PHYS_PFN(res.start);
> +               kvm_nvhe_sym(pkvm_protected_regs)[i].cb =
> +                       lm_alias(&kvm_nvhe_sym(its_emulate_forward_req));
> +               kvm_nvhe_sym(pkvm_protected_regs)[i].nr_pages =
> +                       PFN_DOWN(min_t(u64, resource_size(&res), PAGE_ALIGN_DOWN(GITS_TRANSLATER)));

I don't think the ITS likes to be called an animal :P, and the next
sentence is missing a word after "If the page where GITS_TRANSLATER
is".

nr_pages is 0 for a resource smaller than a page. Could that be rejected?

> +
> +               i++;
> +       }
> +
> +       kvm_nvhe_sym(num_protected_reg) = i;
> +       return 0;
> +out_fail:

num_protected_reg is set on the success path only, so out_fail leaves
it disagreeing with the entries already written. Inert today, but
could the failure path zero it?

Cheers,
/fuad

> +       of_node_put(np);
> +       return ret;
> +}
> +
>  void __init kvm_hyp_reserve(void)
>  {
>         u64 hyp_mem_pages = 0;
> @@ -57,6 +103,12 @@ void __init kvm_hyp_reserve(void)
>                 return;
>         }
>
> +       ret = register_its_emulated_region();
> +       if (ret) {
> +               kvm_err("Failed to register ITS region %d\n", ret);
> +               return;
> +       }
> +
>         hyp_mem_pages += hyp_s1_pgtable_pages();
>         hyp_mem_pages += host_s2_pgtable_pages();
>         hyp_mem_pages += hyp_vm_table_pages();
> --
> 2.55.0.654.g21b8a5bc05-goog
>
