Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4055813D539
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 13:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748006598; cv=none; b=OVO1JtnqymTKTEwGplzygElDkrZNS2pufo9v/bRqdhUdmxAjZw7DkNne+8hHCFx2kmGgke/0lSLyzq6tSzxv7wPHlgXKTI1bmZQSoLxoOvpcRf41zI1X3IksjNa3IRl2joGBujvWjNBnGJvGIat4UDRWjexxdkPy6cnwk7pJA0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748006598; c=relaxed/simple;
	bh=SrcDCUTIC70sGYaQl07hekJ+h2jHUZmOGNdE4CiH5HI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DCrHsSYT33XQvsIxcqiEgVWUOM65Ys4fkMkpWoxCjZGrJSQFP8XkTbYtqZrdSicYNw9uPliQ3rRZBLSpMdtd7DT49wcoG+kSCmefbjywxSOtvRw9NQHjyEgLwZzoL8zZpODIFEaVieLqG1p4HL6QkREId4TIm+XyTS6oP239IRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4b3m3S4PkDz6L5Yb;
	Fri, 23 May 2025 21:19:48 +0800 (CST)
Received: from frapeml100008.china.huawei.com (unknown [7.182.85.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 6907214020A;
	Fri, 23 May 2025 21:23:06 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml100008.china.huawei.com (7.182.85.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 23 May 2025 15:23:06 +0200
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Fri, 23 May 2025 15:23:06 +0200
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Cornelia Huck <cohuck@redhat.com>, "eric.auger.pro@gmail.com"
	<eric.auger.pro@gmail.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"richard.henderson@linaro.org" <richard.henderson@linaro.org>,
	"alex.bennee@linaro.org" <alex.bennee@linaro.org>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"sebott@redhat.com" <sebott@redhat.com>, "armbru@redhat.com"
	<armbru@redhat.com>, "berrange@redhat.com" <berrange@redhat.com>,
	"abologna@redhat.com" <abologna@redhat.com>, "jdenemar@redhat.com"
	<jdenemar@redhat.com>
CC: "agraf@csgraf.de" <agraf@csgraf.de>, "shahuang@redhat.com"
	<shahuang@redhat.com>, "mark.rutland@arm.com" <mark.rutland@arm.com>,
	"philmd@linaro.org" <philmd@linaro.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: RE: [PATCH v3 00/10] kvm/arm: Introduce a customizable aarch64 KVM
 host model
Thread-Topic: [PATCH v3 00/10] kvm/arm: Introduce a customizable aarch64 KVM
 host model
Thread-Index: AQHbrVvRKlWe4qTsaku+jGkyYZoxlrPgb1/Q
Date: Fri, 23 May 2025 13:23:06 +0000
Message-ID: <de7db6bc22ad4f0a8ac1fac718c810a1@huawei.com>
References: <20250414163849.321857-1-cohuck@redhat.com>
In-Reply-To: <20250414163849.321857-1-cohuck@redhat.com>
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

Hi,

> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Monday, April 14, 2025 5:39 PM
> To: eric.auger.pro@gmail.com; eric.auger@redhat.com; qemu-
> devel@nongnu.org; qemu-arm@nongnu.org; kvmarm@lists.linux.dev;
> peter.maydell@linaro.org; richard.henderson@linaro.org;
> alex.bennee@linaro.org; maz@kernel.org; oliver.upton@linux.dev;
> sebott@redhat.com; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; armbru@redhat.com;
> berrange@redhat.com; abologna@redhat.com; jdenemar@redhat.com
> Cc: agraf@csgraf.de; shahuang@redhat.com; mark.rutland@arm.com;
> philmd@linaro.org; pbonzini@redhat.com; Cornelia Huck
> <cohuck@redhat.com>
> Subject: [PATCH v3 00/10] kvm/arm: Introduce a customizable aarch64 KVM
> host model

[..]

)
>=20
> Code also available at
> https://gitlab.com/cohuck/qemu/-/tree/arm-cpu-model-
> rfcv3?ref_type=3Dheads

I had a spin with the above branch, but Qemu boot fails,

ERROR:../target/arm/cpu64.c:57:get_sysreg_idx: code should not be reached
Bail out! ERROR:../target/arm/cpu64.c:57:get_sysreg_idx: code should not be=
 reached

From a quick debug, it looks like the below path results in an invalid ID i=
dx.

kvm_arm_expose_idreg_properties()
 kvm_idx_to_idregs_idx(0)
  get_sysreg_idx(0xc000)  --> id_register seems to start at 0xc008

Haven't debugged further.

I am running against a 6.15-rc1 kernel after updating the Qemu branch by,
./update-aarch64-sysreg-code.sh  path_to_6.15-rc1

Not sure I am  missing anything. Please check and let me know.

Thanks,
Shameer

=20
