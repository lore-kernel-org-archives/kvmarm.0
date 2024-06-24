Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045C41A01CD;
	Mon, 24 Jun 2024 19:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719257688; cv=none; b=iOzAJkZt64MAUn8PcBMGw8AGYVIWLuL3KvPTf4ciCWj2SXmlfFmYiFTIUhNz15Sc6gYEWf2xc/xsZF6QHo6nHtXGfPKwxOVyCppqPuj9VXqmUREeEey5No/LcshqXg4OW50i3gtzEseDCJgb/rDOEIYwdvv//PsMh4DHusLx+/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719257688; c=relaxed/simple;
	bh=8t9uR2Qp4QcE+tK7B/+CSTZzS6eAQ5JnRtkOeSYjS8s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qDh4hRREBfHtuw0o/OpxuSeWUM7oWIVfYH1F8sgcvHDliDGcbk7IDjLDwsynfQfE0JNb1oRahLeofEhXZV8DLQ+2KFpX66pBRPCDeuP/LgT4O4FDC5iPNvjp0A+EwV7A99RWQFkEVPNmBGx71W4k/SC+1Qm1SrLBeez+NE7kvW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4W7J5p6Cd9z6K9gr;
	Tue, 25 Jun 2024 03:33:02 +0800 (CST)
Received: from lhrpeml500006.china.huawei.com (unknown [7.191.161.198])
	by mail.maildlp.com (Postfix) with ESMTPS id B89FF140519;
	Tue, 25 Jun 2024 03:34:42 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500006.china.huawei.com (7.191.161.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 24 Jun 2024 20:34:42 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Mon, 24 Jun 2024 20:34:42 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Oliver Upton <oliver.upton@linux.dev>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Linuxarm <linuxarm@huawei.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "maz@kernel.org"
	<maz@kernel.org>, "will@kernel.org" <will@kernel.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "jean-philippe@linaro.org"
	<jean-philippe@linaro.org>, Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: RE: [RFC PATCH v2 2/7] KVM: arm64: Introduce support to pin VMIDs
Thread-Topic: [RFC PATCH v2 2/7] KVM: arm64: Introduce support to pin VMIDs
Thread-Index: AQHaWqKYmx5fQRdWqUK/xtfkrTETwbHYEaEAgAARp0A=
Date: Mon, 24 Jun 2024 19:34:42 +0000
Message-ID: <99b822b154504531b490055bc0f4006c@huawei.com>
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
 <20240208151837.35068-3-shameerali.kolothum.thodi@huawei.com>
 <ZnnHbM0p8amCqkeJ@linux.dev>
In-Reply-To: <ZnnHbM0p8amCqkeJ@linux.dev>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0



> -----Original Message-----
> From: Oliver Upton <oliver.upton@linux.dev>
> Sent: Monday, June 24, 2024 8:22 PM
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvmarm@lists.linux.dev; iommu@lists.linux.dev; linux-arm-
> kernel@lists.infradead.org; Linuxarm <linuxarm@huawei.com>;
> kevin.tian@intel.com; jgg@ziepe.ca; alex.williamson@redhat.com;
> maz@kernel.org; will@kernel.org; robin.murphy@arm.com; jean-
> philippe@linaro.org; Jonathan Cameron <jonathan.cameron@huawei.com>
> Subject: Re: [RFC PATCH v2 2/7] KVM: arm64: Introduce support to pin
> VMIDs
>=20
> Hi Shameer,
>=20
> On Thu, Feb 08, 2024 at 03:18:32PM +0000, Shameer Kolothum wrote:
>=20
> [...]
>=20
> > +unsigned long kvm_arm_pinned_vmid_get(struct kvm_vmid *kvm_vmid)
> > +{
> > +	unsigned long flags;
> > +	u64 vmid;
> > +
> > +	if (!pinned_vmid_map)
> > +		return 0;
>=20
> Like I'd mentioned over in the other thread, returning 0 for error
> conditions is rather confusing unless one is staring at the VMID
> allocator code.

Agree. It gives the impression VMID 0 is valid.

>=20
> Can you rework this to return an actual error (e.g. -EINVAL) on failure?

Ok.

>=20
> > +	raw_spin_lock_irqsave(&cpu_vmid_lock, flags);
> > +
> > +	vmid =3D atomic64_read(&kvm_vmid->id);
> > +
> > +	if (refcount_inc_not_zero(&kvm_vmid->pinned))
> > +		goto out_unlock;
> > +
> > +	if (nr_pinned_vmids >=3D max_pinned_vmids) {
> > +		vmid =3D 0;
> > +		goto out_unlock;
> > +	}
>=20
> You need to decrement the refcount in this error path.

Hmm..do we? We are here means refcount is zero, right?

>=20
> > +
> > +	/*
> > +	 * If we went through one or more rollover since that VMID was
> > +	 * used, make sure it is still valid, or generate a new one.
> > +	 */
> > +	if (!vmid_gen_match(vmid))
> > +		vmid =3D new_vmid(kvm_vmid);
> > +
> > +	nr_pinned_vmids++;
> > +	__set_bit(vmid2idx(vmid), pinned_vmid_map);
> > +	refcount_set(&kvm_vmid->pinned, 1);
> > +
> > +out_unlock:
> > +	raw_spin_unlock_irqrestore(&cpu_vmid_lock, flags);
> > +
> > +	vmid &=3D ~VMID_MASK;
> > +
> > +	return vmid;
> > +}
> > +
> > +void kvm_arm_pinned_vmid_put(struct kvm_vmid *kvm_vmid)
> > +{
> > +	unsigned long flags;
> > +	u64 vmid =3D atomic64_read(&kvm_vmid->id);
> > +
> > +	if (!pinned_vmid_map)
> > +		return;
> > +
> > +	raw_spin_lock_irqsave(&cpu_vmid_lock, flags);
> > +
> > +	if (refcount_dec_and_test(&kvm_vmid->pinned)) {
> > +		__clear_bit(vmid2idx(vmid), pinned_vmid_map);
> > +		nr_pinned_vmids--;
> > +	}
> > +
> > +	raw_spin_unlock_irqrestore(&cpu_vmid_lock, flags);
> > +}
> > +
> >  /*
> >   * Initialize the VMID allocator
> >   */
> > @@ -191,10 +263,20 @@ int __init kvm_arm_vmid_alloc_init(void)
> >  	if (!vmid_map)
> >  		return -ENOMEM;
> >
> > +	pinned_vmid_map =3D bitmap_zalloc(NUM_USER_VMIDS,
> GFP_KERNEL);
> > +	nr_pinned_vmids =3D 0;
> > +
> > +	/*
> > +	 * Ensure we have at least one emty slot available after rollover
>=20
> typo: empty

Thanks,
Shameer
