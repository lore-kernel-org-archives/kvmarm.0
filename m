Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2036.outbound.protection.outlook.com [40.92.53.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9369145FFF
	for <kvmarm@lists.linux.dev>; Fri,  6 Sep 2024 07:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.53.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725607154; cv=fail; b=HADKp/RDvoaUpuxb/1qORS20QB5HpD/DZgYULy1leCAz61Zod0M+hhskNTk6eIjSE8OdkcIXk7HA6eUsWDmC1xJJ7/rj8P8y9ZJJc+ZggWRHnF2XBuy65jJoPl7qLUoT1+yPXX/k/n9YDE4aTGXGhhW7ss3M3fhxoIm+BjvBmn8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725607154; c=relaxed/simple;
	bh=z/xLH4zstEKE7N9u0jweyG3rDSdW+L/5pAq8iAskwdw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oslBJXeInrLJGSWFUUac2HDspoPLDAxMpLJot0CvWj6KsSEC3B86sj7sKqkq1lQimHwfbvyMfH0wbZV/o68Ynyuk9XfATfyVOAfeaI3Cnv9hr6jzrNzQcUOx+5LgK4hrjNMpa6KaFJq9IC20ipyy+e1mL3IarZnTTjQ6VUFe+Og=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=WMAGYB8q; arc=fail smtp.client-ip=40.92.53.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="WMAGYB8q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QDfFIw0xqnBNQPhONsK/58VbMDI2smHhtgsHxHXe8uYsHOUVHCwTVpId3V0iCuzvW5dbwWGIcMFE3nBGkNnnlUID5lrfQ/e1TpXPTNTkTrb5J4P8PigcQRlVINBUVjcFfhQ07yjoUG8IYOSqzKwHQMZSEAH5uPjzf9a17+tn58B4G/7w6wKvGERF5/Vypdcv2G7wKx0jZJeO+7+g6+/WLhp/tYi2fDdbOAg2udogNEngyGSQjOSvh5FPjVqv0NfzMoKualiAa50Cdyj0pqDXc2g9dF3iBglHsvISTWlCFTt3zu1VSsWL6QSdQD7Z+hA78duYU/DbInhGR8y8eKMT7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z/xLH4zstEKE7N9u0jweyG3rDSdW+L/5pAq8iAskwdw=;
 b=aL/t/WBJEHxgRYax93yZAXbxEncoEFJRf5c2qjKhNrsKDGgUmX/FinTjfOu3Q2QtFrPxA2UD0iw6W/XzmcyN7fNKlBr5MtUNoCMhKN58oUUHNMGLx3XRJH4FHDH1dTuHhy8Xb9YkdNXyRphm2sGjD4yedmHm8Zj/YRcP2FbmbUwUiSyzopvPK9HoSyR0Get4QqXtCLBxXJW/3ZdO2I9FMG/GxaceVJE5ekkBc0dlTfORZnfePTarUT6c9WgdusAXa1G9+ttsCQJeCvZ280+cldOhwP4R3TXSb69EAph/jbsWcLsmSl/BSA+lkePU1iRo2fMbk2sAQ+v3QLaBSKMuow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z/xLH4zstEKE7N9u0jweyG3rDSdW+L/5pAq8iAskwdw=;
 b=WMAGYB8qeDNyCd3bWcAhZ8kxzsbg3PpFsYFCD0ALrXICF8x7Zx7D35VevCXiSfNQz4OrHNBRSRbgkXGdiA81vvb3Poq9tZzv37zoBSOSx3oOXBuBO7Jf5/Bbl/8sMiWNCyUWojcpmY3p4KIn30Fh182MdgHs4REfm543MVyCIr9/FWu0BsKouatVB+WaZ1thAkuCcD0ntZtaQ0JLhWxgIdG9I0qqXT2XZfloWPebG0cLQoOiE0W2nT20st8aSHXVI5Xs3Y5Wf58FVBk5LwoYaffw7vCmKlX3ErnX2C1AVxBvbxN/SK9iXqzsAB3Zz114dfnCsUyUmTmE6ondnra2hg==
Received: from SEZPR04MB6319.apcprd04.prod.outlook.com (2603:1096:101:a6::7)
 by TYZPR04MB7029.apcprd04.prod.outlook.com (2603:1096:400:44e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Fri, 6 Sep
 2024 07:19:07 +0000
Received: from SEZPR04MB6319.apcprd04.prod.outlook.com
 ([fe80::8a6:22f0:5560:f3b4]) by SEZPR04MB6319.apcprd04.prod.outlook.com
 ([fe80::8a6:22f0:5560:f3b4%4]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 07:19:07 +0000
From: Qixiang Xu <qixiang.xu@outlook.com>
To: Marc Zyngier <maz@kernel.org>
CC: "oliver.upton@linux.dev" <oliver.upton@linux.dev>, "will@kernel.org"
	<will@kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] KVM: arm64: Make nVHE ASLR conditional on nokaslr
Thread-Topic: [PATCH 1/1] KVM: arm64: Make nVHE ASLR conditional on nokaslr
Thread-Index: AQHa/10xN4eXue8VL0iYhiu2J/myqLJI15uAgAGDn6A=
Date: Fri, 6 Sep 2024 07:19:07 +0000
Message-ID:
 <SEZPR04MB63194C0FCB4765A8ABF4A2709E9E2@SEZPR04MB6319.apcprd04.prod.outlook.com>
References: <20240905061659.3410362-1-qixiang.xu@outlook.com>
	<20240905063026.3411766-1-qixiang.xu@outlook.com>
	<SEZPR04MB631983048A8586896CEFE8829E9D2@SEZPR04MB6319.apcprd04.prod.outlook.com>
 <86mskmv7ts.wl-maz@kernel.org>
In-Reply-To: <86mskmv7ts.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-tmn: [N4WYE08sevJEt7+4yW3bGdGmggM2Agzi]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SEZPR04MB6319:EE_|TYZPR04MB7029:EE_
x-ms-office365-filtering-correlation-id: ec9b7801-d876-4b87-97bd-08dcce443229
x-microsoft-antispam:
 BCL:0;ARA:14566002|8060799006|461199028|15080799006|19110799003|15030799003|3430499032|3412199025|440099028|102099032;
x-microsoft-antispam-message-info:
 zNsqx9LsQoBVXYIE3m6IoZK4cgX0E6C4yyUL+I75RnKAN6o6Pn6SDjvrX7lW3ubxuVUPb2Ikm2YokgJpQKipgQY5RkPX0mGIwsyIa3asZkACLUrjXYnbL/jbF6yUrIacLzesX8P5urMKSNP4hg4Lk6n/aY0Kv35Zkl5A2BIRNd0PJl12mwoySMPSZB/wv7W0zzTHF/BKssUI+TO2z7J5nRfIy/yuYtLyqQXAu+AKMCRqN3YERjBpHNGpJS3aVGMLwkVN6M6pClRX2xInDJJ1KhO4lV1Pbvads3k6ENIixUQe04REJNNZQ+k9uj5WQnVDG7h7tSuUvkS5UDaiTPXQ6Nw1O27ctQq2GDaLoXvUMIPkjqJdUPv8oIbl400zY1ZSI3WypM1aoz8AefS0gJBEqS60zIKzL4ffOU+Wn2/tvt2sXgU5gtxjCKrb9SqsapqoTUXTe4nAn3fl5X2OTtloi5FuEpf2zHi0bLXIabXfnvW2bWlMSwR2OwG6+kBC02hW4NDXt/5OpRO/3olfKsGVgg+IYTCvQTOnH1sfefTI5AVdWVkhgof5AXgrH5hFCxSlDpDoM28gnATjhGja1vSU4n/n974QxWE71Z8tgONxX2lElSVEn7vSMiuV5ARGCVXpqFURcF9aWWf7eFCzS+F5qGj+xUhRiXUfnv/I4w0m2Mi9HQQOi/EsvTzNz0HuEiqvrM88ivrL/h8N+T4G4Rd6/w==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?rqV5jriA10J7kIBnBnkXoHu7KVwX4vIJi/cjAOhDejhAF+ALvCIHjoCBJJ?=
 =?iso-8859-1?Q?3xEgFC0W/SjooL5cvlOKSyVPZN2XwRwE4R+NwWgClIsv229Y/8Rtr6va8g?=
 =?iso-8859-1?Q?hvQ1NJQil845hw9c8tOlPbPexnsrCYg8ed7wm3WVrC8lDJQSZGsBNW1+lF?=
 =?iso-8859-1?Q?3/mQ+S9E/W8Xhl1R2Xmt1a431GoOC9XMkI+rdcMEVrfpNk0xaViSzECkyr?=
 =?iso-8859-1?Q?0XF2h1PBPhvDRWk3lnxnB9fyihou3xrgu0CxH/Tm3ltkXJp/KN/6B+v4Ri?=
 =?iso-8859-1?Q?fV8D/LwTwDjL5HRolH8x+ajpOTBjrtZSBzh1eito2gICbAeo1e7GHpUYdk?=
 =?iso-8859-1?Q?/4iAhTXwtoRUugy/YYGTDB8lgHd6/O/9tQwPjQ+GU33k1BZ0jsDOzNmHzk?=
 =?iso-8859-1?Q?xePw3q488oOLIZh8mpn2KOLpyYiRXFy9GiOp2JRu5uVUGxtTIUQCEZxWYz?=
 =?iso-8859-1?Q?nlZb4oO3foTX/m62/qqCv+yZac5KAY1Ul4KSeCUQgdFjYYtqsBndo+xsNd?=
 =?iso-8859-1?Q?0uUobEo2JRQN5Z/nVSDjzsdaagMNAo/c4iOfCpGiHwf2IoYlSYiOnrcXOM?=
 =?iso-8859-1?Q?AYShrlc97OTAQxcebk5MB5478JJ8S8JCVNSVDAE1eEhUwEESqR8H+KNXw+?=
 =?iso-8859-1?Q?cpWhSgs/8SCnU4pLcsIQpz7eYeXdZ5TrrrFVjFdpUyDClDFOSQu6f78Riq?=
 =?iso-8859-1?Q?4wXxH/GbeUw0cGOmA1chpnBg80cld+01bi4ds9kIZFREJcXEN9IDJsjoJq?=
 =?iso-8859-1?Q?/tg+vSAMNo+ud4UMhrVravanyC7rv1bAzzupHHx/uXAITXmdFPCeroqC3g?=
 =?iso-8859-1?Q?TZVc4PdVThkfgl/z4WiFGvvXtvaPHYWhbAA9aYalm+BbGChzw7JeklRCKu?=
 =?iso-8859-1?Q?0R871cUWPPNjs+rkwSs8rB2M4anOkn8w0CLxP6nO56JnOvofkdICIRu5tx?=
 =?iso-8859-1?Q?dhoazMI26rgSqNWVVW5Em5PlWmo7DULsKTwmVEF/3Vs2PvclUTTXX9/fY7?=
 =?iso-8859-1?Q?++seIGUIiCFQjMqv3udDXTqGczPf2uhantyaI9cFm7NTZWZMduCnqFWyho?=
 =?iso-8859-1?Q?PWFIpIKqbBn6bxfJIzO7r1JdXCO/AFhxe8gmXg23bxnMMFyDB72OthU6KY?=
 =?iso-8859-1?Q?e7t8rroje624L4noy8CQxfUsJ5PqKHEvjE4PN6Di4lM4EPsEE7C0wv9ZHQ?=
 =?iso-8859-1?Q?lmgcSH5q9UN78ZJNQL8CYZ8l/jjAiBLKSXu8lgS4CNxLZpIURtnyX4D8ec?=
 =?iso-8859-1?Q?V9PZ+WvbnQDSV4tz2ufRZjWQk2UxPtKqf5cBcO2gE=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: SEZPR04MB6319.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: ec9b7801-d876-4b87-97bd-08dcce443229
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2024 07:19:07.4141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR04MB7029

Marc,=0A=
=0A=
Thanks for your reply. =0A=
=0A=
> This is a change in behaviour that would leave the 2 implementations=0A=
> affected by Spectre-v3a unmitigated and leaking information to=0A=
> *guests*, while they would have been safe until this change. Is this=0A=
> what we really want to do?=0A=
=0A=
The reason for adding this is to make debugging nvhe hyp code easier. =0A=
Otherwise, we would need to calculate the offset every time.=0A=
Do you have any better suggestions for the debugging?=0A=
=0A=
=0A=
> This is also not disabling the whole thing, since we still do the=0A=
> indirect vector dance.=0A=
=0A=
I'm not sure if my understanding is correct, but based on =0A=
the hyp_map_vectors function, the address of the indirect vector=0A=
is only related to __io_map_base and is not random.=0A=
=0A=
=0A=
Thanks. =0A=
Qixiang Xu=
