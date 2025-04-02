Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB7023BCE7
	for <kvmarm@lists.linux.dev>; Wed,  2 Apr 2025 14:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743603302; cv=none; b=oTgR8Im3Vk29B+s5+rcvtdzGqepAsjNzV6Hl/3gS9cJabQB2VEhNZarJ+u1csafx77B2l4oxQ3Y25HNCbjN9eIJsiHvETMRaXyd0xXLfDiYkvd+LmuPLlYu1stkJ1iWv0u6mVtkeTmkE3/E2vAH4U5h4FA6eTMbl5A3v9qSCJmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743603302; c=relaxed/simple;
	bh=RekemI21winZSkN/4ZTNVhN87O5VbRFw+71Y2jqcSSo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pmcgQHYXiOxczXi0ME72oSg8thVG5EVinXrwdKCYXtT71dcvJjmePMCpVPpP9G2ZaUIo+3MKUN8UlCH5MNfnobJQqLkNo2JxIYqDw8PRS7abuPZRvxnhH/2HDk212+gaS566zBzPorOi55yav0bUL3y0tWgCjekghQwpOLbHv6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ZSRcR295Sz6D94P;
	Wed,  2 Apr 2025 22:11:19 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 3892A1407DC;
	Wed,  2 Apr 2025 22:14:58 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 2 Apr 2025 16:14:58 +0200
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Wed, 2 Apr 2025 16:14:58 +0200
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Sudeep Holla <sudeep.holla@arm.com>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "maz@kernel.org" <maz@kernel.org>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nichen@iscas.ac.cn" <nichen@iscas.ac.cn>
Subject: RE: [PATCH] smccc/kvm_guest: Remove the accidental semicolon
Thread-Topic: [PATCH] smccc/kvm_guest: Remove the accidental semicolon
Thread-Index: AQHbo9Xb1Qaum+PVw0qFOb1Na1wSkbOQRVEAgAAki3A=
Date: Wed, 2 Apr 2025 14:14:57 +0000
Message-ID: <fac61876ab13495ca1b4ca2a94cc735a@huawei.com>
References: <20250402134401.146156-1-shameerali.kolothum.thodi@huawei.com>
 <20250402-independent-hyrax-of-honor-4515fb@sudeepholla>
In-Reply-To: <20250402-independent-hyrax-of-honor-4515fb@sudeepholla>
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
> From: Sudeep Holla <sudeep.holla@arm.com>
> Sent: Wednesday, April 2, 2025 2:58 PM
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvmarm@lists.linux.dev; linux-arm-kernel@lists.infradead.org;
> oliver.upton@linux.dev; maz@kernel.org; mark.rutland@arm.com;
> lpieralisi@kernel.org; catalin.marinas@arm.com; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] smccc/kvm_guest: Remove the accidental semicolon
>=20
> On Wed, Apr 02, 2025 at 02:44:01PM +0100, Shameer Kolothum wrote:
> > Fixes cocci reported warning:Unneeded semicolon
> >
>=20
> There was similar patch on the list [1] few days ago.

Ah.. I missed that. Please take that.
>=20
> > Fixes: 86edf6bdcf05 ("smccc/kvm_guest: Enable errata based on
> > implementation CPUs")
>=20
> ^^^ Is this really necessary as they get backported as well ?

Actually I was of two minds on this. Not sure.

>=20
> Since, KVM maintainers are in cc-ed, let me know if you guys want to pick
> this ? Else I can send it as part of my firmware (ffa/scmi) fixes.

Thanks,
Shameer
