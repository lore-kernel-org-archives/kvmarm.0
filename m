Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1CE4A207F
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 18:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789583037; cv=pass; b=GFxvCNHQX83irJ17qOrDadhrxi+bot9PpCRlqrbb0zzA1UEPJoLynY0gbQKK6ZP/1IzF5M38cXIlNnkHM7gvf97kbcb1ZgaVOFO4m4qoBrxrKj6og6sROie0NBV46xk5jMpxD8wcu9lmfQ21zuLkuYZs1L8LNfiENn2eyqpvF/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789583037; c=relaxed/simple;
	bh=K1VkZN9Ax/ivqRQhY6l3VgzDLSp6+7t77YixSnLTILA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sDrkY4kTBVkly27rjYW6cVrb11FNu+bE66347HoKJSPE0h00pBGhG0qvl7DW6Eys+p7/r+fhGOLdn87QDIdFDVQ4ht0sgYSMtcpD3n9lvQvqYwueqoM/p5lXyvveUUpjJ6EFAsLCK4Xc1CebITDYhXInnP5aYql4q9Ms9bM4T48=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JDPChipd; arc=pass smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JDPChipd"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b5e4f1b846so1698235e87.0
        for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 11:23:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789583011; cv=none;
        d=google.com; s=arc-20260327;
        b=qvL6idPMPC6H8iTwdE2omYFpDu8sION55FAxMe3rzdKUG3DOQVvfAnxeCNKUQT2pfR
         cZXGdbFaESh1+/Gf7vCfKDmzUe32COeUvjdZpuVXQRF+5OGM67TWe9SRLAT1mOukud5W
         iBsCM1EE0FToTLtu5bjKHlu5TMTiudQQUjCID4O+mbkHmlKX5l1HAXbByMZUzGdz6DN6
         /xuq0HPPUjdzQWu/v8Ir/3GpKcRcCF9IXxDEIxGG7vLzBbVIyuT1+d1iZCtfHRJ/irbY
         ZmEO7F5ipgc1fV5sa4lPyQOTlT/RWwiaRChFe7eLaGH05ZIje7PAkC87pRwjFkCP8jbI
         IkIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iA6WOY7U5Hpnzgqa3cIbAuP1d1sT3cNwxEh5sU4xF5Y=;
        fh=VyX9z3jySm6QV4VgD9Ix5Si/QMLCPzz3oa83KCHC9bs=;
        b=qTxpEDUVOnNTfGTarQp8KTQyz1KdpvICXNwnjpoSAAroC0H+yWRIshlDP+TyxHZjvw
         POBBM5Lj2gn0ei2R8cvGod59SNbtMzfglw/SVEMaXZjoMRsL9g1sBJV2ir179MGggrIN
         O5rcd3pKm61dL2RSs+6KTvBv9koANHNHcmGYoKRh8OA3gv5NoC6ybItcMMb34KmPfcHB
         V0jw86ONSR8xo5HkTcmI4ksRI7haLfP2UesebJQWtcaWGvc6WOJwCvNCksTQsvj/O4pV
         1Io45Akwj5d7RGe+qNNP8XoTIscUrLJzWKU0RMjbCcqL4WZ9UUx7HeZdhCwPcKcON3ee
         wPwg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789583011; x=1790187811; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iA6WOY7U5Hpnzgqa3cIbAuP1d1sT3cNwxEh5sU4xF5Y=;
        b=JDPChipduRYrBvPo4aR28TNSvEdUz7CQX3aOqzKMBUu8nUv/A6WIzWUOnHRAVqv1Kl
         6WJG8I5KOtcWTuit0h0R8WpHELpIGT3ZPeFYYm9bo71wOGaEVzRI27MYoSAQPimJThwz
         j7V0m36C+jXei/RgjYHdcOUUsrwqB0YnzKoyhtIsTvEl0ClIgrlZ1q1ar0Fyuod7RyCt
         CRyU0EjdhcmAbxNiieNvprkory5j63zXzQVMNrlzt6bt39N2BWEmbC24f2M2qVsdx1Br
         a4ld038GxHBPW6OYqGQ3PxbZCVtVbFNSjnZ4ETbr8SQR1MX0ur2ZTsSxdYfjrW+ktvuF
         fAiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789583011; x=1790187811;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iA6WOY7U5Hpnzgqa3cIbAuP1d1sT3cNwxEh5sU4xF5Y=;
        b=nsUj4KIYmzMvOsSfRbTqrL6JMtQt0QknvhrtB6doD7lOLn6zpGFlh16dKKGsdRFDET
         juu2l19GnzXDz7If9pLMywkmb4Zg8MNOA5WdRrimV33syjX5rYXo6q+rpTRuIL62GRwz
         ShAREXD73DWYFC5U2ZUiJguWOA3yc2cpqY5c8KJNfxvpRywKsWZXpQ8urt6h86P9sNcB
         AU0n2rjGD5ix4QxrA4ggHRLP8gXKEspBeXtLryqr84kdfzvO/DMZGyG/IZQlVvEt3m4n
         Uiers1EIl+/IJY3MZlcV3aFEbxzy9HL6+9g4VSKZ/6iJ1WDqHa7a/T4nTlaGtzzETQXn
         ATCg==
X-Forwarded-Encrypted: i=1; AKwUvBwYBWSqKSK++Wna6USLbRCSWhO/u8lbqU51x4Yw127Ek+CVF8Lfqt/23VnhdAu96unwaDUKj/o=@lists.linux.dev
X-Gm-Message-State: AFuF++mEYYqQF7fca5zDh20BtXqUd/si1hdQA5j9Yp3bgE4XXogQga10
	OX/LwxuHtKUXCF7mhqymMz1RE3W6Q9ZgsnVAOl1fHXTmDZBGyG9FVKq7YhWUFwFPHhJFSChcZX3
	z8nNFVHXSPbuIkx5OX6yMfL3RnfGQYTeW8xIEX+Dk
X-Gm-Gg: AYBFou0S1ShB71w1PYUPeRDcg1USJKNnjWAcOAyiW39vo0EWuUKbhGIZJfUBgakt1x1
	S903NAe7uW7/cML/dO4qBTLwdLb9zsF8huMLAujbmuqZxbIep5tNbckDbktd3mhc0G2jYtcPB2t
	oEnTZKh+0jw9ZOihWhv9E99bbv0YEpB1XZSeapZtW1R44Hcaqp7hzILw8WPneVs3ZMfv+klL2zJ
	hRGoTXAvTK3X1olpkei1nWmYznYpk8Rliej115EVWLLGBl0uAhuPnuwuQYUrjSRyArIFGRhbEQO
	GjontgCVM/KzX/vqikxqvQWGBAU9PoMM+aBVJxkfhvVtiZX69fztqw==
X-Received: by 2002:a05:6512:1293:b0:5b6:1a7c:aa13 with SMTP id
 2adb3069b0e04-5b8b6640be1mr1009695e87.43.1789583011057; Wed, 16 Sep 2026
 11:23:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260912083611.2513845-1-suzuki.poulose@arm.com> <20260912083611.2513845-7-suzuki.poulose@arm.com>
In-Reply-To: <20260912083611.2513845-7-suzuki.poulose@arm.com>
From: Alper Gun <alpergun@google.com>
Date: Wed, 16 Sep 2026 11:23:19 -0700
X-Gm-Features: AcwNN1Xa9rZlSKbZ1HJXqNvz676wwtG0Dzc3HxbzhCyZpg8GXZHTQsxrOGLMh6o
Message-ID: <CABpDEum16ZzLSjd7Yg2Ge6VjwL8S8xxtSs_AsqOeNT9-9FNKKQ@mail.gmail.com>
Subject: Re: [PATCH v18 6/7] firmware: arm_rmm: Ensure the RMM has GPT entries
 for memory
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com, 
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com, 
	sdonthineni@nvidia.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 12, 2026 at 1:37=E2=80=AFAM Suzuki K Poulose <suzuki.poulose@ar=
m.com> wrote:
[...]
> +static int rmi_init_metadata(void)
> +{
> +       phys_addr_t start, end;
> +       struct memblock_region *r;
> +
> +       for_each_mem_region(r) {
> +               int ret;
> +
> +               /* Firmware-reserved NOMAP regions are not usable system =
RAM */
> +               if (memblock_is_nomap(r))
> +                       continue;
> +
> +               start =3D memblock_region_memory_base_pfn(r) << PAGE_SHIF=
T;
> +               end =3D memblock_region_memory_end_pfn(r) << PAGE_SHIFT;
> +
> +               ret =3D rmi_prepare_memory(start, end);
> +               if (ret)
> +                       return ret;
> +       }

Hi Suzuki,

What happens if a system has memory regions in memblock that are not
tracked by RMM (e.g. CXL memory)?

Currently, rmi_verify_memory_tracking() returns -ENODEV for untracked
regions, causing rmi_init_metadata() to abort and disable CCA
system-wide.

Shouldn't rmi_init_metadata() skip untracked regions (continue) with a
warning/info log instead of aborting? That would allow Realm support
for conventional DRAM while leaving untracked memory for the host.

Thanks,
Alper
