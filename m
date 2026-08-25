Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5A311CA9;
	Tue, 25 Aug 2026 04:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787633278; cv=none; b=B7QP36rMdKawjXMjAdFhUJV1pS18u5MRBn93tqoT7Lf9HWYa1QaYNzQoGLDcYgJ6euqlEwoieQex78m7ushLkObZK8TVaC/e5ZWZZg2h8uWSkDdx8hdUaPNw/tfI3eBS/Lrc1mpL7fItMw84jLvSh/s6tiykSx1dymojx2Ee1rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787633278; c=relaxed/simple;
	bh=n3UnF/NeuQEfm0iKF7UvO1oLPGe8Ac5Q8v65X9fzj7I=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ssFmM4ZKDXGm7GP0rErS3bD3QGMitHDV6y1dauckjTmDsafC4VTGvaqN+7WplEpnmX8L7VAJ49OtBEWdMNAAQDz1x6ctyHISgqZLKzZELx6D3ztWC7gcn3O3WzFYW3qabqHJiJ85PN+OUVJMPJ77bGl3yEr+9omBKZHb8Nc89bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DZl7VmH4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DZl7VmH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3ADF1F000E9;
	Tue, 25 Aug 2026 04:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787633276;
	bh=fnP3yoFqLam+q74txUte20YTRfVEWgC/MsIo7AxFy1M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=DZl7VmH4Ir30bVjC5iewzEv7a7Z7T5Hvw2yna97sfwEIejxOFkt5tysmWCT7c87Og
	 fK5mfv+auM7enlFKM31SEt5BBsp2byAf4mGOyuB5b6HDtMZ0GR6dlHEfqM45hpPOOI
	 dp6d0gXiTYUnRZbj9VqqZlEIO7s6F9QGuUlTgIdz13LYHqrASHXXAsxnztRS8uNf3h
	 GOVt40tpM60e6p/NVoO4TpbkcC9aZKkMeiMqtvG/5tLNFSBOf0pC/G9OSNHNYMzDg3
	 8E9spxVhUzaEtTqRjFQxlvwB4RySSI8or2I9o+sD1CMDGbdEO72GxJJx1go7cgymtb
	 bE3US+z8iImMw==
X-Mailer: emacs 30.2 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Kameron Carr <kameroncarr@linux.microsoft.com>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: Re: [RFC PATCH v4 09/11] coco: guest: arm64: Hook TSM accept to
 Realm TDISP RUN transition
In-Reply-To: <f086f940-edaa-4bd5-ba11-e52e61fd6cee@linux.microsoft.com>
References: <20260427082805.931832-1-aneesh.kumar@kernel.org>
 <20260427082805.931832-10-aneesh.kumar@kernel.org>
 <f086f940-edaa-4bd5-ba11-e52e61fd6cee@linux.microsoft.com>
Date: Tue, 25 Aug 2026 10:17:43 +0530
Message-ID: <yq5aik4yx0uo.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Kameron Carr <kameroncarr@linux.microsoft.com> writes:

> On 4/27/2026 1:28 AM, Aneesh Kumar K.V (Arm) wrote:
=20
...

>=20
>> +	/*
>> +	 * Present the private mmio range in the resource hierarchy.
>> +	 * We don't use this for ioremap, ioremap check the RIPAS value.
>> +	 */
>> +	ret =3D pci_tsm_mmio_setup(pdev, tsm_mmio);
>> +	if (ret) {
>> +		pci_err(pdev, "Protected mmio setup failure\n");
>> +		return ret;
>> +	}
>> +
>> +	ret =3D cca_map_evidence_report_range(pdev, tsm_mmio);
>> +	if (ret) {
>> +		pci_err(pdev, "failed to validate the interface report\n");
>> +		return ret;
>> +	}
>> +
>> +	ret =3D rhi_vdev_set_tdi_state(pdev, RHI_DA_TDI_CONFIG_RUN);
>> +	if (ret) {
>> +		pci_err(pdev, "failed to switch the device (%u) to RUN state\n", ret);
>> +		return ret;
>> +	}
>
> After calling pci_tsm_mmio_setup() we have mappings from insert_resource()
> then failures from later return codes never call mmio_teardown() so
> remove_resource() is never called, only kfree on the tsm_mmio.
>
> Likewise after cca_map_evidence_report_range() the mmio entry memory rang=
es
> have state RIPAS_DEV. Later failures never restore RIPAS_EMPTY.
>
> Could clean up be handled better? Is there a reason these failures don't
> have a rollback path?
>

Thanks for the review. I=E2=80=99ll incorporate these changes in the next
version.

-aneesh
