Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF49E8F49
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 06:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781850524; cv=fail; b=IjuU67s54UOEZb0ps7yXa5gHuUSYST54NMDLXvQDHgKQyy99r7bKEp/ewLe1VSdwZIC4MFuMrkoMUyUZ7xW9mJoWYXplrPf92XgTYw0ZrxsRKsxPHFBPyNeXaUxjryryARbMWgCep/nJYzeF5I4XU3s4QEYldSEeddMcZLGkExI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781850524; c=relaxed/simple;
	bh=lia0ZSOxCzwDqFF93iyvKfC047HuHMesvEF8reHv8gM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=A/dNJBx3bifs50K5gGPfTgiftvnv/7rUEdR6p1KNNCkaby4wU8VAI8TqFQDgxkV7E4Je4RfBbR4ZMvwpauzjq8Si9uXMWrrOLrfu0bQiU0N7enZIrotKIz3CKioVEqlXqAVGnweYAJXpXaLMgsMOxso1AaKaUhkik6pYzLirXfg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=E5uojAV0; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=jA6Gyhdl; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="E5uojAV0";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="jA6Gyhdl"
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65J2wvc72410091;
	Thu, 18 Jun 2026 23:28:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=gMloCzP1zaILcPJHJLBdixZpesXZ+yG4Eb5Lb6M4X
	jI=; b=E5uojAV0zZ7nkCRziR3cUbJWcGm7DqF4dB19h7zz9LlGJwIIlYJkudUPA
	DseOR9JVxMY9PUfuyaSwI/tx11ef+/k5uNIlr/8eiU8TCLpuDjlOQ7N/DnbSxomN
	nGcjtFdvLwvssa3FX8+BXGmfdxYMWcNUNiIEffRAi2QzhzGH0Q8x7AyuZgLNQgVo
	/fy2OcopAwUyNLcpTWSDGf3uxU4RIvyHrMNq3ae3ro76+Oh38EW0MhTMppWpPgkg
	iaRolEZK1TJ7o7K6HYOB2Jw4l/sz53SsF+a9F/d0bZeLPoTju4Epe2W3sIcj0yLU
	JC7OEzMNpRX22xumJGYlXpEt5WtCw==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11023075.outbound.protection.outlook.com [40.93.196.75])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4evn6dsqab-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 18 Jun 2026 23:28:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nN+wBObyRBlfIn5mXfE/NZqPemPURkW++bP982XqEJQ0ToqWZQ19ZamRWzeRjUV3WK/0TESCbXCzqSKEmhTV0n5pz7vBaP/JxBqWMsGJdcnySmfdZbS+i1MWF8o009hCXStDrDH1ZTU6PcmlmNz1JH91UKF6YqOn9pHlgpjlU0FPKCV3KFc8GpPEZuU9WpB4+fNDhIMFUtsnOa1ZpoeHvVfUM6bxFpyQPpDyfc1yCyWaDpaIazF+Ck+P3Kv6oCh/Mr/O9sauccMijB3BdusBgfJJJ9oWIeGhMGIvvoersGsESANEJzat9feaOl+rusDn+UZK0mrEZMn5UEZka7dzgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gMloCzP1zaILcPJHJLBdixZpesXZ+yG4Eb5Lb6M4XjI=;
 b=ecKawEMz7Gd+R3c0IiyJ2m1l8KzqIDZjln5os4lE8SAt/c6/yDCPW3f92zWw82ntl1Wxml693uAeyXxN5z5zgana3V8spsbCpS/xcSmj9S65yzXXhJ5hCp8uPk6TfhKdm1NYewxnlwJibo4mDJsfeupZ74UBsC2wFg/YZsZuzBEtG38borlZIHpFLpyjh74FijZqZtpS82gXb12QRX+zOZz/a0M5AOk+pLcHv7x3qoWOC/6swT/BBplGRVors/3WK3+on01ceQrEkbLf9Zusntn7zXbC0nuy5f9HQ6TE0MktkzTyfcsOAa44rWDgC7tj9a82t7LCjF6wGm+yAabORQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gMloCzP1zaILcPJHJLBdixZpesXZ+yG4Eb5Lb6M4XjI=;
 b=jA6GyhdlrNF4lB+HEZYSk3uLZx+x7L0FFo3f44rmxpdH2jX2GPcZ1094vBfDKuJ+g1wmFblJTwcQvWz0RuENCx7ru78Cs/OQAHYz2Uc+oHgXey+m3wO+b0kABGg7SPW4AfXtjknGrVaoCKTcEQyU7Y0rIMAvtqdPN+bzLLY54nmjkGFxU6EhEX92SwZtM/QkFbsyWSRJRnAZLgorqoe8Savg1ZZUdjdgClvWxnwDRoqXgOJTXJtDB2uDQDWwYoVwnAiaiKyAGOJs2w9FWhptm/121bv4mQhEuwdo/b5inZbRi+957gJ4wVpye6g14JfQ7U0p06iFDXN+j4ufpIvX5Q==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by MN2PR02MB6687.namprd02.prod.outlook.com (2603:10b6:208:1dc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Fri, 19 Jun
 2026 06:28:23 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0139.009; Fri, 19 Jun 2026
 06:28:23 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Eric Auger <eric.auger@redhat.com>
CC: "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>,
        "yangjinqian1@huawei.com"
	<yangjinqian1@huawei.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "sebott@redhat.com" <sebott@redhat.com>,
        "skolothumtho@nvidia.com"
	<skolothumtho@nvidia.com>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "berrange@redhat.com"
	<berrange@redhat.com>,
        "abologna@redhat.com" <abologna@redhat.com>,
        "jdenemar@redhat.com" <jdenemar@redhat.com>
Subject: Re: [RFC PATCH v6 08/17] target/arm/cpu-idregs.h.inc: Generate enum
 values
Thread-Topic: [RFC PATCH v6 08/17] target/arm/cpu-idregs.h.inc: Generate enum
 values
Thread-Index: AQHc/ZPomOg44z8SEk6s1CA9S25yprZFbnMA
Date: Fri, 19 Jun 2026 06:28:22 +0000
Message-ID: <F517E5C6-EF76-4D2A-97E8-6C232E3CE3DB@nutanix.com>
References: <20260616132625.1732031-1-eric.auger@redhat.com>
 <20260616132625.1732031-9-eric.auger@redhat.com>
In-Reply-To: <20260616132625.1732031-9-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|MN2PR02MB6687:EE_
x-ms-office365-filtering-correlation-id: b00889e8-c0a7-470a-9de8-08decdcbf677
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|1800799024|7416014|366016|56012099006|5023799004|4143699003|3023799007|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info:
 KGQZrIebEXCFrcQzK+mjQpp0yRmizlOMgHyNKMf0bUXvv3WLo3KkYyiMvP9Nk9fvxYSHebObpdRljIXROQX6Zc9A7k7hRH7llbpxeVF0tV7EEbD4s5LtyDH9wTruMVYG/ZbR0dnrSVUDvuNxnq9j618bb69BzSX9ncFyMQMDdM677zWV1RYlPyH9KnPX3zK2sMPrkxjjc712vHB8PhITtASOWyvRuXTYboxs7vKMITtjT5C+bX9+taJuaib7QXLqaIBpx4M7HPKZXiFx0SbG8ftUixg9aGCUMGpb8hoY4MlDy50DC4Q290WzHhP1QVc2ihDDRQ2IzkjWGIZNAuZFqbTZKZzt04qtA1ZtviBql6UagLAnqZCYt9TvH6fHcE4RbK/pMrE0vU1K/eLsZaLa1LW+JSHiRf9OUESGspzA89m+KxXZN2IwhaemJYSki2pu96lPRv4iuLtmKaAbZczCW5Lwc1gmxwQuamEtvbjtgyVpdz5C4if/aMFV2553IAssN7DwB080R4S/qBcTN/x9UxzUPau+HpWhGXHWdUEBoapyYKo0DhTzNbcW/5wDZCBdr+H+JzF3Ob+Rzkr8Dk8bgz6P9pdY4+s6MzQbRm+TSzoeETlkgtwhmIsVoT0zpJKEFqvTjA10VnmNevdVdErc2VBAXre0xTj2WLLZoRKoo2cPzL8kapL+PuwdfmA+bMa8SQn4xFqnQXScLxABX1V+ggeXHUaMI2ZQWo6ss1QRAi0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(7416014)(366016)(56012099006)(5023799004)(4143699003)(3023799007)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?90ClA9D0q8IMTFJkC07tTimEe11sJ9Iey7brYJxrYP22kSdiziBQAgdR3kB/?=
 =?us-ascii?Q?jve1Lbrosh9ga1gJZNiDM5AP8HRDl6HZQIe9oMRymBqGiMoyvhfMDl4ePh65?=
 =?us-ascii?Q?SubmzPQJywP6AYbRWQYybE+YBuHE1U77/HDdXxvqyV7FZNG1gMvfV/ygOyrq?=
 =?us-ascii?Q?AxNWdLFz7fsmftwtQcMRbjggSOjGQK+AcvS5C4Cyb9CWehxVqPSad/o2U4zL?=
 =?us-ascii?Q?qh93WxCBhxFHnGt4URT6T0EA108DlJeMmL3KwTB9jFm+gTIncxemK0Yi8PIX?=
 =?us-ascii?Q?MH0U5D2UtPXzs+ns5qb/vZ/KrXkdRPLYTrTa1x6GIe22siVgK6+kygKxdW1k?=
 =?us-ascii?Q?uSkFm0Y7jM+3Xgv4txTW0tuPeINQJJYLp75J0+a1Xh8semmjtHL7BQ0jUSTH?=
 =?us-ascii?Q?q3/eWzEIOt71jgkow2zACYbrIuQEvlD9I0G9NVLLOaSb/brwJR0CMtUWE3cr?=
 =?us-ascii?Q?3lyi73sm5f64B8MTLEHIUZGcSvhAKhB41cyldijykiuB+92sDeQgzx9rt7h2?=
 =?us-ascii?Q?gorxjyvubxHYJYxmAbuHQDqDiRRcgWWMOF/rSvI13wmMD1extyrUcE9YPJzl?=
 =?us-ascii?Q?qz7CofrZbgUS9ZEJBwvjPKfqEAr1VTAvtNIXKhtkaP8S4ayN/M/NMFDIPZyx?=
 =?us-ascii?Q?586sFbTnVjMJ73d2ToQT0B/kVOeNGpmnSEIzTOCU32kM1gJ9QDyV5SN53wdn?=
 =?us-ascii?Q?AmPrpV5JE6Xav5nrs7W2VD30b2Wyn3MILt8k4mGu0p7TC5HeVaOo9qVvZ2ZI?=
 =?us-ascii?Q?zBsvG1+Uafgh2E9CuZ3AZJWuJPp8jwvPnPAX9WZR5aKyrPJMxGzyV3VSSAPV?=
 =?us-ascii?Q?i6o1OsGRvhgLAanjlrzG7SqnpQI9OHQRXYbDLnl/Vt24WDZYUwkG1zWSjBGm?=
 =?us-ascii?Q?olKeqgq8uteLotIwwnFJxONXVSIW79cP7c8O3PGvBXAPWnoDZMx4VVDvEchh?=
 =?us-ascii?Q?H5aXNnzXzDX7IN4R3D66YxYndzT3fnxGa37THYVLldxuYpG0AHuaPTW7C/nG?=
 =?us-ascii?Q?ms5J6MrIFqDGWaY7Onz7MqzdOxar5HjQkzlWWjSUJtRxlZttYeGEflQKjUSG?=
 =?us-ascii?Q?u9HPBs5TKjHnAXgUyfYS9z8Gg6GEEy5wUlN0Z9NQ4LTn4ij6ezMkLC05r84k?=
 =?us-ascii?Q?VEhwrOj/N69BrndW6Xs6AsxMT81L6uW50/wbM/H0GqT7FWVZIM11+dt0JXq5?=
 =?us-ascii?Q?fz/behFt/0BzCfhujh3lrQwtw27Hc6vcBwcRaYOuVZ2evxH5i7qE1FcY6pfs?=
 =?us-ascii?Q?uOw/ByeJNpzN5S7Yttp+qSPKrn067qJxWouNKxe+6sbju2qTA9SJbo6BASi7?=
 =?us-ascii?Q?A9GYIjb0sw8t4WvsK5A2EV7kSsdi51ILijK70/ZfKQdkyeJLLfSPdm0DFX9K?=
 =?us-ascii?Q?luQmrhFujIJc1+mkqwgYAALxMBolqlAwhG77P6IqCuAZxvCl7nI25hizhRvZ?=
 =?us-ascii?Q?ACSuspEZ2iVFE7+SxLVxqn24KsjK1bnS8YjlwVPG23c7VIEhKXNfnVhxuHU/?=
 =?us-ascii?Q?N05jUctak9/kDlxwkCmoK4UnxwnAqfwHbogU0zQXkz6v3NwUSILkpi60Em/a?=
 =?us-ascii?Q?L2QwOfrzXwaV4UHfWwFG5HTxUKTEKpKjUDAUbLorrew1p9L0stygei4kq4eh?=
 =?us-ascii?Q?OBBWk+B1eRpFUtqiWHoirE0Z+oVMXpMT4MXR2VhoeUqJ6Qybxlg3R5lLFAlt?=
 =?us-ascii?Q?KkkTQEpMbeWp1Y8ShYYWWJdo0oHnrCaZiqnDQgaWNvwDGfMsfhkPI1BQ4kXP?=
 =?us-ascii?Q?3Lcj9m8XXMuzd1WuiMnHCeZ5jepPyyM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EDC6ABBA5498A441B93940EE8F0746EC@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	BnD8MmAOkH76mNKj9PeiC38INrVJAmqVi6Nsu2XL6OVzVkp1e6ynxZIgg6LWoo/AJurkDs1APbhA5ATU0Vi8bTbnjdnmPzxoXAjf/yqFFRXf0ZGzsWuy6n/XNI8MuAp0Swoy6+jkzzzG/pSfSyNo+5UD3Hp3MQsipr26HMhuRIEd/eVt291qmG+dhRW/DT2v88XLr5CJHX2aIGhI3mGtfxl9yRMXs/lVmZ2jAvpp6pHoYP3I6zp7ij/pESQhBIqHshVcJnMCbKsxmvRgTil8Me762WLz9/IIrXNue6DCu3EfTiPgc5OWap5Kud6AGT2syzaBmjAqMh/4NaoHcHctNw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b00889e8-c0a7-470a-9de8-08decdcbf677
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2026 06:28:22.9991
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TTRipUVR0+WEDzbZQ4i0QXWCYkp+hLevYcy8iphE3MVmgWTI42NTGyRsWMq6HgTyywM23sGqbZDUlemkF5tyT5JWNW8A8gD/7YAEEwFerIE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6687
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE5MDA1NyBTYWx0ZWRfX91U1R2Zi2v6N
 Rw92/UuMKwoJcANOy+X0E733zS6LkcMmzt9AA1SsNsbuEQXPzLXQVYfc/oZGRN05+rMh7wXAQ/x
 BC/eAVweQxCECgMh48WdE5RXqe0QIRTErS/t/FrBzXVBMnSFYVYBcrEYnsl38y7PfNyoG0m0C46
 5NzCRN8qEpt3mSb8XD528RmumUR7zdvaMP/o9Nx0EZ11Vuq5Z6Bq9uwepxj3MrkWcuv0DWU5iyw
 Tnp1wm1Pc9blVRaYSn8IckAsCs8VC/dha+IFkVDUNiBrvV/oSLfZ2FeUZ0fhlWI4Gu/69QfMOUp
 YI8ENApeH/T7b5asWUNMNLquySmmSfhcMljDE7cpP4bblaa1076WHRSoQH20KHMxd1andmOINQq
 ZRtJCAJQxIYMZDlVcZmVKFsXc9mYelQA1WG3ENqNYr7Bj4Equj0pLlroYRVMnVMgGuNIgcV98V7
 iP/aUqNNmOkPXQ6Iavg==
X-Proofpoint-GUID: FlrV6petsMNPNZOmAyOTq43k0Wn1-Jli
X-Proofpoint-ORIG-GUID: FlrV6petsMNPNZOmAyOTq43k0Wn1-Jli
X-Authority-Analysis: v=2.4 cv=AuveGu9P c=1 sm=1 tr=0 ts=6a34e18a cx=c_pps
 a=ZwnHHYtbhvZyeoWvue1Gvw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=y4UcunY2MAxhM4LwGdWI:22 a=64Cc0HZtAAAA:8
 a=5xgeuzQ2IVJpFVg1fhwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE5MDA1NyBTYWx0ZWRfX2kKXMKbnNtA7
 wk9suE1ReCM24981UAYwi0Z2HracK2lLPgV+V7Yxy+/sLh+giYAEQrnggrj438IUC4TX3+5jmwO
 ILOfvsdB5rItzPUNBYbTEOQyjwwmGLc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-19_01,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

From f0e489cebdac1ba94b8082bc240f2d889555f7ea Mon Sep 17 00:00:00 2001
From: Khushit Shah <khushit.shah@nutanix.com>
Date: Fri, 19 Jun 2026 11:54:29 +0530
Subject: [PATCH] scripts: bug fixes in update-aarch64-cpu-sysreg-properties

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
While rebasing I found two bugs here:
- It outputs incorrect value for field that defined a ValueRange.
   For example, CTX_CMPs (and all similar fields).
- decimal 10 might be incorrectly parsed as to 2.

Sending inline patch that I have added.
---
 .../update-aarch64-cpu-sysreg-properties.py   | 56 ++++++++++++-------
 1 file changed, 35 insertions(+), 21 deletions(-)
 mode change 100644 =3D> 100755 scripts/update-aarch64-cpu-sysreg-propertie=
s.py

diff --git a/scripts/update-aarch64-cpu-sysreg-properties.py b/scripts/upda=
te-aarch64-cpu-sysreg-properties.py
old mode 100644
new mode 100755
index 9e829fda2e..2e28b03598
--- a/scripts/update-aarch64-cpu-sysreg-properties.py
+++ b/scripts/update-aarch64-cpu-sysreg-properties.py
@@ -106,6 +106,29 @@ def collect_fields(item, bit_offset=3D0):
=20
     return fields
=20
+def parse_value_int(raw_val):
+    if raw_val is None or isinstance(raw_val, bool):
+        return None
+
+    # may already be real number
+    if isinstance(raw_val, int):
+        return raw_val
+
+    raw_str =3D str(raw_val).strip()
+
+    if "'" in raw_str:
+        # quoted bitstring like "'0100'"
+        bits =3D raw_str.replace("'", "")
+        try:
+            return int(bits, 2)
+        except ValueError:
+            return None
+
+    # unquoted, try decimal
+    try:
+        return int(raw_str, 0)
+    except ValueError:
+        return None
=20
 def extract_field_enums(field):
     enums =3D []
@@ -124,32 +147,23 @@ def extract_field_enums(field):
     if not isinstance(val_entries, list):
         return enums
=20
+    # A Values.ValueRange field specifies start and end value for a range.
+    # Don't enumerate anything for them.
+    for val_entry in val_entries:
+        if isinstance(val_entry, dict) and \
+           val_entry.get("_type") =3D=3D "Values.ValueRange":
+               return []
+
     for val_entry in val_entries:
         if not isinstance(val_entry, dict):
             continue
-           =20
+
         if val_entry.get("_type") =3D=3D "Values.Value":
-            raw_val =3D val_entry.get("value")
-            if raw_val is None:
+            int_val =3D parse_value_int(val_entry.get("value"))
+            if int_val is None:
                 continue
-               =20
-            # some of the values have ' like "'0100'"
-            raw_val_str =3D str(raw_val).strip().replace("'", "")
-           =20
-            try:
-                # convert into bin=20
-                int_val =3D int(raw_val_str, 2)
-            except ValueError:
-                try:
-                    # Fallback to dec if not bin
-                    int_val =3D int(raw_val_str, 0)
-                except ValueError:
-                    continue
-           =20
-            enums.append({
-                'value': int_val
-            })
-           =20
+            enums.append({'value': int_val})
+
     return enums
=20
 def generate_sysreg_properties_from_registers_json(id_reg_names, raw_json_=
path):
--
2.52.0



