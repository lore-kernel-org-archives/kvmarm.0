Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10olkn2104.outbound.protection.outlook.com [40.92.40.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1101863E
	for <kvmarm@lists.linux.dev>; Sat, 28 Dec 2024 02:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.40.104
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735351293; cv=fail; b=kvUKgGXQCAwxRJhFdDMH4gYQrqtEVIfzDNQiGdrO1IbqhnZd3lIYaDFme8YKrE5wHTTwJz++mbGc96+LvFQP9Yl6DEMu+RD/K3zd9+dQkpeotHN9RCmlG1mXZ5qasan0nvRq4or4GLGG0vdJA7I7YNJJCtc82d03Fzv+j4YjHv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735351293; c=relaxed/simple;
	bh=MyoInFUANRJ8YiKPEILFiXptH0URQ03IO5DSxNOM7Es=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=KBMcr6Q8P4pTmQZPLZhqB17fvXr2oBJxEYyu/g8Ug5tc+mfupMbTOb4TwwUFYiW++e0QRMzO8acH3tj/mXse5V8yuXuLq3oSBj9Vb5QmS0115hqhSu/cXF9JQIEiBuPjpJ1FmSJ45eXYNyOwFj7rLTud5FqNZlt4NYdey5jD/yE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=L2Zz2Kqg; arc=fail smtp.client-ip=40.92.40.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="L2Zz2Kqg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bs6WW8kmdQgLGY5bnm6sWzQ1WcB3kW49udL8iX/rJewKZFe7kT0Q9083m6/qxpJiHIESiqtadjVCS1+wOEeq8JcCVOg8r/ksttVix/e1G7VNSzkhbqReHNmt3/9TFysqATKYee6nwoeTEojrV3qIeIaqLPycEXk8ejb8P3I17ypB7Z12mUhUlEm3qWaeUtQXbHH8s5zYiLZUWJewgCd6Bf/XNuhY43OYQQI5qxKdXGqkQpMxurfxJcyG/7H48lZA1rivVgUl4wKGrXsADN2W3AGTYIr7i/cCdT9hhUNzEf0OKHkomagpF0j62c4k+7O4ixpTRKy54/wrNJqU2/7SXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RAW63aFjDrsMk3na1YDUUo56y1xRAx/GTgUsUIshXmU=;
 b=MBkiuzPuV+Y0Y5MHkZxQfdgdJ40VfpFp6DqN31eB8wsJtvpHr/h2Sum/GVbk+QQUWRMkCetLEX0EceAkZ+f2sjxuo/047VLL8GIs6wvYkFDCj1q55Ar9xoObIGn54SaPHGf0hLqX+8maM8gPtTmbSEiDpfL+2uoYlN+uqxssrF5WzeKe328PLEdwurfz7dnOfznW7Zqhm2QoaRlBD5jySwh99S7ZeBgUO5wefxSq0FFJoCYGRZsb/7As2BzDBVlQRQIYFb1tS15IXq839w5niz0RKaUo5VL/22KVvh2GKHtPLUwHeV0O4fJrS1Z22IEcvz8xTKGVn9mTBuPnwc0usA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RAW63aFjDrsMk3na1YDUUo56y1xRAx/GTgUsUIshXmU=;
 b=L2Zz2KqgX440c13BF8/bBSskS1F5ErALx8YMFrW904GViC1lG56DqLTNIwZ/U31DGuoWeDzqGBohqeTu2NqfD2uElJdGB7iK95LAMHvE09tH/snoyrEYUkkWbEkMmRd6TVZxZTgPqvmkO4nf4JCZwYbnAuYL6gy18fnzxi8xgP8DEOlTgnxJefJFiv+OzAiiKQJf2qt+l/gq6TiUePRfzyA7Sq16quUHeVSNT7fyf22izP5Q6PlZsKRqqcp865jzfaMSLKsZ6hJjKLfWgtKNTEDEdmKVXp691qm3lha0uJVn7fCdKzGZ1l53MVlTlTa1tOQoZf7aT4RQnfoqE2Pf1w==
Received: from SJ2P223MB1026.NAMP223.PROD.OUTLOOK.COM (2603:10b6:a03:570::8)
 by BL4P223MB1359.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:5a8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.14; Sat, 28 Dec
 2024 02:01:27 +0000
Received: from SJ2P223MB1026.NAMP223.PROD.OUTLOOK.COM
 ([fe80::b5cd:c37a:bd3e:e3fd]) by SJ2P223MB1026.NAMP223.PROD.OUTLOOK.COM
 ([fe80::b5cd:c37a:bd3e:e3fd%4]) with mapi id 15.20.8293.000; Sat, 28 Dec 2024
 02:01:27 +0000
From: Steven Davis <goldside000@outlook.com>
To: "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>
CC: "joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Steven Davis <goldside000@outlook.com>
Subject: [PATCH] arm64: kvm: Fix potential overflow in len
Thread-Topic: [PATCH] arm64: kvm: Fix potential overflow in len
Thread-Index: AQHbWMxnX+FBSwywOku5TBqhZiIaKQ==
Date: Sat, 28 Dec 2024 02:01:27 +0000
Message-ID: <20241228020119.12379-1-goldside000@outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2P223MB1026:EE_|BL4P223MB1359:EE_
x-ms-office365-filtering-correlation-id: 61c398a7-2e8f-4d4a-5479-08dd26e38a52
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199028|15080799006|8062599003|8060799006|19110799003|38102599003|440099028|3412199025|102099032|1710799026;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?QaUjHQLzVW0hrjAJHz77vAIlwz8DNcDEPk6Pm4DINktvkSkWY2+Nw/+daO?=
 =?iso-8859-1?Q?RAwP8FUa4wTEXKTS98yclz+u5k6pfOKdif5FfTJULQSTiY+B8KmPy59rZP?=
 =?iso-8859-1?Q?+w4E9fMGJgjlVhiax/545Y9qzh2l94f7/OOxuaZCLHYL39jyIW3wmjGSw7?=
 =?iso-8859-1?Q?egEIq18Ygra/Iftqi8TUCkfT9pEpTPh+sH+R7HCYv0Dkth+fdNvLyGmnSU?=
 =?iso-8859-1?Q?Bfc2K/aEc9cGTpAWYIj39P8x4G77tvaqysj9a41oIXKuEikuryEkX0pScW?=
 =?iso-8859-1?Q?H92x7JVuUk7Fg4McImyf6k29D3s2jFMet0cOOU8bVIzA6MWcRmFGXDLce9?=
 =?iso-8859-1?Q?6nJCxXyFJmEYYcTwKmDd6jb5gde6hl70kvtGTutHpqQW9UrhAq2g9KdkWq?=
 =?iso-8859-1?Q?PT43uKbAOMXPdYTBaVRK4A06V0xcvuE6eL9w/LjXy07qA2sbtoFBnwC1ak?=
 =?iso-8859-1?Q?sgkam+N9lDNUiZk0iKkfUVX2bE8NyqC0RCZWowFlKAEnGvm00lyvEbrXnL?=
 =?iso-8859-1?Q?FZB4Jfo+sSGu6+m9dZwkj23NTUGBFrYKf4uzrZeI9/+yiZGH3epb3BjqfG?=
 =?iso-8859-1?Q?mwCeAo0qae/ECLNFQ1/tMmxgI4kECWxMyTRMsmlUWENHlYEt4jxZFubAqV?=
 =?iso-8859-1?Q?6+MKxxYcwtbF3oByPqyEx+U81yjl/3wo6gqlvmOJ/FurpyDOMXXRtzCBG5?=
 =?iso-8859-1?Q?AbqV61x5di7ngBKpyD3wfejiB6a/I2IyGjNltbRDNJ7I7w09EuudXAeRZc?=
 =?iso-8859-1?Q?S9u27eNByE0tiQsX8lZ2U7JcBkoyaudr+KBZV8fM55qGhNnxVJiSj4bnDX?=
 =?iso-8859-1?Q?UtD4725eZeGj1uF0l9f5cKDFJAH+sjrEbnua7znbtfTNyUwJkvoqAl7YOY?=
 =?iso-8859-1?Q?HgdJgJmpNdgA6fzDR9bniNUqM0v4RZdTu0Q7ZZ8XjonhamXrilIv4BZb48?=
 =?iso-8859-1?Q?xca8QlIS8zrLVF14dlkxLBl119ayJD0vNoxpXVDHM+awKkT6qHrtiOKHxf?=
 =?iso-8859-1?Q?mR7xDpWty6OenNoFhZdRNw7vu7iv/gx9OKFeoLfFfhUYx8LTtAoLkIDrxL?=
 =?iso-8859-1?Q?MXtn6JpCZXJaAmfJXNaH0lDmkwRmzyS/SxdmsVVXTPCOnkKIM/Tf9AtNEb?=
 =?iso-8859-1?Q?ssBKq4wH3jJGG0ZAQorMdIw9H+or0=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?j3i3XqFSTNisQNF69RuuIVALpbdqis1Tm7AYPw8jFJLp3udu0kF9o9dreu?=
 =?iso-8859-1?Q?fsoaBxU38j+E9ioY/OA87ZXu7BYqFH37GXAL8wH1PbekY8w0CUcl/o7uIQ?=
 =?iso-8859-1?Q?YwdzwL/kS+c2PXdIbi1LIdZAAPrqWi1NX8SXHyZL+/hYPuX3Y7VWaZR2uQ?=
 =?iso-8859-1?Q?LYEfbaWEMKMsVF34rdsEzNLrck6+kZVm8qxLdIjfOYH8XCe+lhgGzzMDFC?=
 =?iso-8859-1?Q?HQZyoZPfLvwfmInHJXOjdpFYC7IRR+rRghH5y7WkUn8iVP3G4TetzwIfgK?=
 =?iso-8859-1?Q?bwKSMP0dlrZMYmY02VTpV9G143Ul7MODu2FsISDyHZn2WqZP4tjxOTeQ7Q?=
 =?iso-8859-1?Q?y5sCZh7YkUowHLxTzHdPmMbK0DG3sWMZ2lkyoFCqN+TUxqWLYfTW9irLVQ?=
 =?iso-8859-1?Q?zRWmkjc9XCrlcJZUWhqDg0UnpMyLpX05soASDPW1WyxZaB+PFa2JkBI75W?=
 =?iso-8859-1?Q?dghT1Gfy75d5sIwjv3oQScDt3Dfpj4ew7Fx5udSJXStefMfUZ/cOxor7hf?=
 =?iso-8859-1?Q?S7N1FPPjhTZRmtrNf+0ZoSkN1Ls1oxfMJbCPveDxKkm3teygu/QtkW4/R6?=
 =?iso-8859-1?Q?S/81YPnSDzkIDvZ38NyJvyi4d3Vl+WtmbZEk8dg2JZqKavPz49JZkSeHDC?=
 =?iso-8859-1?Q?flaAox4FiVSS+Fp7dDM+7EYT7dunT2N80Z1ASsl0zw4lNVt7HZx5eg/7+t?=
 =?iso-8859-1?Q?w1XErLiwhqfDszZQZPX/0KhoYRc8rXfGe9lTcQ5ZEhPysZf1TlP3g2dEo4?=
 =?iso-8859-1?Q?cBlEgOrL0MJb0YxNw+Iw/qOSjcNv90/rAZj9FMW+qqEmubwnXNl5+QI4A3?=
 =?iso-8859-1?Q?gXFYnjm6a2B/mb0N2tRP2qZqjTlskeajZjpDv+y0K/pvNB/uvy0va7f3mB?=
 =?iso-8859-1?Q?R/Qop+diWsEieiejF31Q9+u5Phknbqw+sXC3RxXEQIsxZ3qgcJbroqjw6H?=
 =?iso-8859-1?Q?X98TK6agWLLSuXyNCfgtVHh1FwBldoko3+ZstUCXkAhvva5FvqPAa0VjpF?=
 =?iso-8859-1?Q?/cEjCNbM9wmCvxGryusa1OLVd2zqYRP8bBa16h+kAV9s2kgVQAK3GMZgoN?=
 =?iso-8859-1?Q?3hnflvWsoSyeeHvdqjGoVw7ZA+aGutZRUWe7rQ91fRv+V1Nm/91hTmXvhD?=
 =?iso-8859-1?Q?MaTpEE/gBYuPTSDC71noTMplze2iJ0ArZrqKgK4NzR0h953KXFHTp2/tqX?=
 =?iso-8859-1?Q?NRcqbNhXfMB3MAf+OiQ65QIaito5A9z3hUkjVYaWphG/CD0PKo3JMZ3iLU?=
 =?iso-8859-1?Q?ENF2Oy9ClBpIJdxfRFYq7jsEx2sQOcmhUgitwYUK4=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2P223MB1026.NAMP223.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 61c398a7-2e8f-4d4a-5479-08dd26e38a52
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Dec 2024 02:01:27.6138
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4P223MB1359

The MMIO sign-extension logic in kvm_handle_mmio_return can
trigger an integer overflow or undefined behavior when len
is invalid (e.g., len =3D=3D 0 or len exceeds the size of unsigned
long). Specifically, the expression (len * 8) - 1 may result
in an out-of-bounds shift in the computation of the mask.

This patch adds validation to ensure len is greater than
0 and less than the size of unsigned long before performing
the sign-extension logic. If len falls outside this range,
the problematic logic is skipped, preventing potential issues.

Signed-off-by: Steven Davis <goldside000@outlook.com>
---
 arch/arm64/kvm/mmio.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index ab365e839..e4132dbc3 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -124,12 +124,15 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 		len =3D kvm_vcpu_dabt_get_as(vcpu);
 		data =3D kvm_mmio_read_buf(run->mmio.data, len);
=20
-		if (kvm_vcpu_dabt_issext(vcpu) &&
-		    len < sizeof(unsigned long)) {
-			mask =3D 1U << ((len * 8) - 1);
-			data =3D (data ^ mask) - mask;
+		if (kvm_vcpu_dabt_issext(vcpu)) {
+			if (len > 0 && len < sizeof(unsigned long)) {
+				mask =3D 1U << ((len * 8) - 1);
+				data =3D (data ^ mask) - mask;
+			}
 		}
=20
+
+
 		if (!kvm_vcpu_dabt_issf(vcpu))
 			data =3D data & 0xffffffff;
=20
--=20
2.39.5
