Received: from mx0b-00154904.pphosted.com (mx0b-00154904.pphosted.com [148.163.137.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FAB634EF1B
	for <kvmarm@lists.linux.dev>; Fri,  3 Apr 2026 03:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.137.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775186899; cv=fail; b=Em8jESvM8HVN7RnMpcY8IwibSf3wWNt4edDtCYOnac1BJtgJo2Dwkvvj1JMStfZSaJlWl+iU3wooh+mkpw+8mUiE9xjOvBqKpEBZN4h0f8sNA6cFMW1rrYN4ZN9WlnQgfjTHBxr5c9mBcJjiKtld7Ur5xxZSAFNDFhvWxcCkpqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775186899; c=relaxed/simple;
	bh=DZ4fFkvA4hIg9U8ks16DNuLlqJviuwaYTlgzTEPVR+w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GuH6Hp8BeBXTKPJuPDFLCpMJSa2J4esN2k4dyxp5NPIBsDfztNIP6a/upQH3yG9SA7Pe26ceL1D9omZYlU1H73t+GqgU1yTJP3tPicugtBOGCbK9akEPBLILJvhPatrnwuBrz3yi/XruKGMyPFUDOvnT2jlubHoYCitFxSlVvwc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=XJ3appyk; arc=fail smtp.client-ip=148.163.137.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="XJ3appyk"
Received: from pps.filterd (m0170396.ppops.net [127.0.0.1])
	by mx0b-00154904.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 632I3hg31434881;
	Thu, 2 Apr 2026 19:38:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=smtpout1; bh=D
	Z4fFkvA4hIg9U8ks16DNuLlqJviuwaYTlgzTEPVR+w=; b=XJ3appyksGgSWwWP7
	tXuZjSgAoxI9bYY6nATCKPYynW65wilPthi54wAD/rBc+yLw4IujsYcbP+oete0L
	EChSImJx+fo8Os+SNx8qDq8/zBq6vtN7KthcLant6q9ihvsHw38WGT0rWPdjwkvn
	eLrEN8qcvJlLU1H7qRSp6Cj0HECGISyWs0MJc73EuAr2h0NoarnvUqMSVD2kjU03
	zJCyh1O5ByoHYe3yXA4SIcpOS3ozK0IhQznHljvXwhSpq1oUK2qjF5M1N5NrFW/z
	sb5459VyLuaLq45DqDXE2s1JvTw4wmG7S9NkdLOSqygaRWovIGxEIqdjumUIvLt+
	j2mog==
Received: from mx0b-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
	by mx0b-00154904.pphosted.com (PPS) with ESMTPS id 4d6atu45mp-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 02 Apr 2026 19:38:26 -0400 (EDT)
Received: from pps.filterd (m0393468.ppops.net [127.0.0.1])
	by mx0a-00154901.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 632NXNH7919418;
	Thu, 2 Apr 2026 19:38:26 -0400
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013018.outbound.protection.outlook.com [40.93.201.18])
	by mx0a-00154901.pphosted.com (PPS) with ESMTPS id 4da1s289ky-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Thu, 02 Apr 2026 19:38:26 -0400 (EDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y3QOvb+9FbWpb+7nA1OS6h4FwGJt9dmBLq2CFSTxtdhVbWjPNdSDVZJZqjr/8egfSb/5IOrhzNbYfL9aR7blDoN3bsRvgrDG/c8DmrprZBXhF0MatBYvRmvVrOCMrN0wnE7BujGl/QXX5HtTPSRmUauHkMGSv+IG8YVg1DR9sfFbb6rp1Yfee86p9YHlRXYrkUkYu6akTfRuTPtTeiQ5rbRnTpyHmKgemA4dNCBz75Oa/lz15EEC/3rsI/acwUx6s7lBQ1+f3L29eFoamOZUMS+eTTD+cO1EkLxAfr0qU7tYR/Z5TMCstRw5fHNILIj3rD7BnusCXtUXFr4hWTZ2hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DZ4fFkvA4hIg9U8ks16DNuLlqJviuwaYTlgzTEPVR+w=;
 b=jXv1+OATvTCntCTLiirYyOKn23nflK8/qxShEC0o4Z2SvMw/Yct+OR4cTpohi/UdTVSjRoCM22CsFBvmhr+Qeno+gEeAUARHyR5mte84j2M7R6dWywl6LDoFjDa8+GHlFtpLo/IehNkBs/dQ+YzmbULijlfFKLLfc77eVLNfzzzugCdWRABH6BF99cCxulx6AAEHuOhxCOHpVG2xv/CCQmjPQ9ZSvWthj27IYUUkvMl9pzfH3osFWB7+rn32Wp+/CaajAvHg8KmNRuzunCNaRVuhw7ZNEhfEFIzDQ9awE+ziwS1fgZ+qE4gayhTMNGIKwSftg4Q6wzkpcOaE7osZqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
Received: from DS7PR19MB6351.namprd19.prod.outlook.com (2603:10b6:8:95::8) by
 PH7PR19MB8139.namprd19.prod.outlook.com (2603:10b6:510:1b6::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17; Thu, 2 Apr 2026 23:38:18 +0000
Received: from DS7PR19MB6351.namprd19.prod.outlook.com
 ([fe80::f45e:e7d6:d522:3d08]) by DS7PR19MB6351.namprd19.prod.outlook.com
 ([fe80::f45e:e7d6:d522:3d08%3]) with mapi id 15.20.9769.018; Thu, 2 Apr 2026
 23:38:18 +0000
From: "Rose, Charles" <Charles.Rose@dell.com>
To: Ben Horgan <ben.horgan@arm.com>
CC: "amitsinght@marvell.com" <amitsinght@marvell.com>,
        "baisheng.gao@unisoc.com" <baisheng.gao@unisoc.com>,
        "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
        "carl@os.amperecomputing.com" <carl@os.amperecomputing.com>,
        "dave.martin@arm.com" <dave.martin@arm.com>,
        "david@kernel.org"
	<david@kernel.org>,
        "dfustini@baylibre.com" <dfustini@baylibre.com>,
        "fenghuay@nvidia.com" <fenghuay@nvidia.com>,
        "gshan@redhat.com"
	<gshan@redhat.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
        "kobak@nvidia.com" <kobak@nvidia.com>,
        "lcherian@marvell.com"
	<lcherian@marvell.com>,
        "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "peternewman@google.com"
	<peternewman@google.com>,
        "punit.agrawal@oss.qualcomm.com"
	<punit.agrawal@oss.qualcomm.com>,
        "quic_jiles@quicinc.com"
	<quic_jiles@quicinc.com>,
        "reinette.chatre@intel.com"
	<reinette.chatre@intel.com>,
        "rohit.mathew@arm.com" <rohit.mathew@arm.com>,
        "scott@os.amperecomputing.com" <scott@os.amperecomputing.com>,
        "sdonthineni@nvidia.com" <sdonthineni@nvidia.com>,
        "tan.shaopeng@fujitsu.com"
	<tan.shaopeng@fujitsu.com>,
        "xhao@linux.alibaba.com"
	<xhao@linux.alibaba.com>,
        "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>, "corbet@lwn.net" <corbet@lwn.net>,
        "maz@kernel.org" <maz@kernel.org>,
        "oupton@kernel.org" <oupton@kernel.org>,
        "joey.gouly@arm.com"
	<joey.gouly@arm.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "zengheng4@huawei.com"
	<zengheng4@huawei.com>,
        "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>
Subject: RE: [PATCH v6 00/40] arm_mpam: Add KVM/arm64 and resctrl glue code
Thread-Topic: [PATCH v6 00/40] arm_mpam: Add KVM/arm64 and resctrl glue code
Thread-Index: AQHcsviCWpaD3S4DS0+oknPXpOz+F7XMhTAA
Date: Thu, 2 Apr 2026 23:38:18 +0000
Message-ID:
 <DS7PR19MB6351DBDFED61A8C9A89DB391F351A@DS7PR19MB6351.namprd19.prod.outlook.com>
References: <20260313144617.3420416-1-ben.horgan@arm.com>
In-Reply-To: <20260313144617.3420416-1-ben.horgan@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Enabled=True;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_SetDate=2026-04-02T23:08:06.0000000Z;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Name=No
 Protection (Label Only) - Internal
 Use;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_ContentBits=3;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Method=Standard
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR19MB6351:EE_|PH7PR19MB8139:EE_
x-ms-office365-filtering-correlation-id: 71f112c3-95a9-41c7-a266-08de9110eb00
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|786006|38070700021|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info:
 N/JMJbde6r9jXaFIUYR0OoQF40qp3I34Sqi3M5K7Q9Fptq7WL1X5vhJCGvTQgOpaLoGOkAoRg0DxQLxCRhw0+hi7v5dmKU9pKz1+kSMktEG78OIKqcnDTYCSvDDwCuTdjCzQ+R4tLTTD1hI6IryhXX2tHsnnyqjC+ckJveh2VuWrgQXC+UeshoXZoLDDBPkket/nSVqkD3fGOqZNAaT8yYCoRLoyvnuuPQHuw+nucOEmcU0ybJzCUVe38/6pb1kPMKRQJZNDdIA8UKHPHKZLIFzNvArZ6D43lEIAtzl7IDh0uPsMDKRVBfJun5NgwUx8Hc3xIVnayWGlQMTMcn+sY575tp5VC4PkPNgOz18qf+iFtI+Zggg+1+xM9pmiS6+S/+VV+PnWy1lRjt586buGZrm0+jig/d3TgznVnzzZ6bKk53q5ocVz7o8fLSryCB7BykXAPaWs5Q0kI+dBu1Bfn7klxqKOgWUYGox61/1v0v9wPYp2xt5mXhX6LlcDJAF4vW8Wh2viwnt569PQg5vpf6hOPU2t5XJ8MS0DwGFGGv8pxFgX+aAXxB6fCTOWOAHOeNzUA7SVy0+SodWZajybX7n9Jct96Csb065kZ1ZDEq1fbmA8HS4axjqzESXSd+mFWQOo7oSpIe4v13cU1s0itGTHZTXGTqCwtq9t+jiw8x60LGevg9VYYcMUvhwguM9SpbNqBUfoV2jHJ0v+P7tNVI6pv2sy2bZ5RHyF5xbjD6m7udoVLLM60MP5JnN5mKWHFqRZITO+h1KhZdEEErZTWYiYt6l0p78PZ6d7GyAtVhs=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR19MB6351.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(786006)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?8g1jb5baJUaz5dxv3WSJ7TdSaGIhg78+ovbXFosLvE0o6vl4qKjZX4+3Xa7h?=
 =?us-ascii?Q?I0aGm0N+TEoAD3PMY18EZ3KAm1qGUFudrCt63vtqp9y+AWdg8upmwFCoG6gW?=
 =?us-ascii?Q?jwUNxwh2bvcLa+ru/nMTSikE7M4NHfJpKzHtV19DtKMquHs35dC1PNegE/B6?=
 =?us-ascii?Q?bbvSbuROR8hC1bVuTZMfa6A6niarHdW/BfCVAA9VsvPUI1KGVg4mq3PqKLb9?=
 =?us-ascii?Q?3mXtXcnRw26WEy2qyp4Yo/Jp+IQyH8KLPf7IAXZUqEzT/NbOHDNYfplBpAeO?=
 =?us-ascii?Q?cmmLm3TQQj7T+G8pDezY7bxgp+3O/I8L05DgBep2g8UBJSlcZpfiPmeaSaSY?=
 =?us-ascii?Q?nhImgJDYLjpXY3W8yVsHhsccFlltxj4Gnb11SfM4a4WHs8Mnh9H5fs6feHBO?=
 =?us-ascii?Q?XPT+f5xVqjlZIdOItZ7GmeUBEltnYAsv4f6AxuGTsgnRWyKfb4hamd8E30uj?=
 =?us-ascii?Q?tqNG5EKZgpwZyTzZaS0oBT5wo6rnft7uHscQ/cy8AcnomDT+BDlx8ulbN51n?=
 =?us-ascii?Q?Xx4lks9JbDdsiIQzIzgteWWZxWHPh1R8CsKQkPlNnJsbfRMaWnMMqoI1DhN5?=
 =?us-ascii?Q?equ302nd5pLs1lMpDy4bdnOFC+GSVuvcCq+TrnHluU0TUzsEM89Dhihr33xp?=
 =?us-ascii?Q?OCl2fWd81lr9CiIhIlMg3P59zuNh2pt2Qi87cqfqCZN/SUFN1PTlpFyRZN/R?=
 =?us-ascii?Q?4bekmL071iUhRCnNn1FgPYOk/cVz0/fR+2JyokaWe7YpuZI1j4UqHLZx7i86?=
 =?us-ascii?Q?3mxovS67A+So6K8mLXiK9ZcifOinFLR8E4cf23d7kHTvp5BEQBNvgK82rBZB?=
 =?us-ascii?Q?vtmZDoxak+KIXVTBd0TgNrINwb8BNwMpKgr7gKEu28N3ujpuyh8GV6FkChVG?=
 =?us-ascii?Q?9Knk6MQ9MvZkJOwN+v2F6AosG42k84VTvM9WZfhDU5c/4TnMbuLHehz4yegy?=
 =?us-ascii?Q?fgkE4fZhF9qDpFv8WFmBWL/+i9rmd5QLHM/fM6AReYagORL8aA/IKIHmRAQg?=
 =?us-ascii?Q?T3sD04RUSQQv2if+LYxaZsnZycLJwLvN1ZNYZ2ZGJG0HePajkAJ7JdW6JeRS?=
 =?us-ascii?Q?a1rycbeZjUiYEb2XXwbgrz/gNRFEH78rRRtBC9C54l2Mm5ktNHB7fY1OA5VI?=
 =?us-ascii?Q?F0zLVV0uHFhu9bMxw2E6d5KXRCy/TBANFy7PJZ+oGjXfqySDDIbDaTRpNefc?=
 =?us-ascii?Q?kIZa94wZc2G5myVf9U0rwRJl+Tz8UTTU9HWarJbWIm18/0qwhkMjIyPqdTPs?=
 =?us-ascii?Q?y3CNN7FxmQWRnuoMe8J7vYHTmn1Ia7FPE73qJgK68aTJajtxx+ZVU4F1CURL?=
 =?us-ascii?Q?nzB4S7DlsAHX9Ykc5wzKE/P/hgW32T0sWO6rgbZS0t3TE8jMKPoisCbaxgvB?=
 =?us-ascii?Q?2eUNf/eAAAHQhil2W3mmurimbofQQ1jZjlwo5jIe9X05OKhSMRkatxTVF1/L?=
 =?us-ascii?Q?OcP1ReFWGcRA6L7TP2eN6p3FwwGMcky5IIyhDtgvb8nfWdSncQ2EcNI6sIrt?=
 =?us-ascii?Q?Fmf8lf11pRvJnV7GII2/Qzhzk5+tE80nwAgHKAejv57gF0lCIz8FXizO1xQU?=
 =?us-ascii?Q?bq7cN9L2/S7h7X35SVThmvaTuwsYdRqSv8Nbxh+wvz5SsBP1dxmZ1zWAJZTQ?=
 =?us-ascii?Q?e0wAp6iP24jZt/VOpwdyXlvaT29Ost8IR9/sxp6sqh02NLKBV/1zlaYRtdNz?=
 =?us-ascii?Q?mfsEHrIoi50LjQ6WaH0QeNZnpYdCgjfY5URhjazZTKnUgtT6gZ8rMwYY45Sp?=
 =?us-ascii?Q?ui5N4J0IiQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	UacYLJJDpEOgq4QjIb9KnhzZbGr0R48u0RQUh9a+qD0DaBvTll05prO5ySkX7zsQjy8CxQU5UjTKfw3i9Bud7rMyaxligEp1HKwI1WQ7eKI7Z9DsLvAIFl8zU9xjPhFUKzXEvaKnsLGjdfoK+x28863aTSTX1wmcEpft43wFCXuEW2elQZQHdSP1MFuk/JNuY9noAmsZADlXQ6EwfY/EHEuZo7ICku9AwbQqG1egGOuJB8ZYPlhNSG8uTrzB3FNp5ubXZM0mQIzW2f9yxCQbw1Hgqpc/prVkyoXt4Hb3uJllRZbW1UsefHur+QEWxAndW7mv3oqpW3Za+dTT3NKjRw==
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR19MB6351.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71f112c3-95a9-41c7-a266-08de9110eb00
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2026 23:38:18.1189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zGfWIeT+JCHt2+ZRtZwQ8AWhfdwPdpoOxPdlUWf28HppX2ZX2hH9LocVxv3ecxO3kOdaCsD7tpmeO9i9hsCKQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR19MB8139
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_04,2026-04-02_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 priorityscore=1501 clxscore=1011 phishscore=0
 bulkscore=0 impostorscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604020211
X-Authority-Analysis: v=2.4 cv=Hp572kTS c=1 sm=1 tr=0 ts=69cefdf2 cx=c_pps
 a=Z2e5DKjA+8LiMDv5v6mwwA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=6gNNCFAoQcIphELLPWWu:22
 a=fe1keu9KhAX5AoWrZvs2:22 a=iLNU1ar6AAAA:8 a=kaXEgJzuHZ3mdCDcgH8A:9
 a=CjuIK1q_8ugA:10 a=hlJyneSgMmFPbskH-t2w:22
X-Proofpoint-GUID: efujn-L-7jlmUNdGDMiyrqGhtXT9Jpoe
X-Proofpoint-ORIG-GUID: efujn-L-7jlmUNdGDMiyrqGhtXT9Jpoe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAyMDIxMSBTYWx0ZWRfX7mYYtkr51OMb
 5UYm8P111vcrC1FELFy0itCrF9kvnduAI3F6Clg4HML7WmPmEuMIdz99KUTSXp3DLF/fBl3V0fL
 zRvo/POWQ2JTH/Wk7/VRuGMZSZ02TF+GXaP5JoNl7PlCVxLpqZOLwczPjKKIW9azAXJDFZlA1Xm
 dW4uxCwV6rF3tKCMjgLIsNu/ITrcAU8uOdhf3l4gfbGy2CcucRPgj7a5tulgxvK6C3B0u1eDpJs
 QOObA09/MFPlC180uDyDrjrIBdFLF+BuQBjshV/EaJlyOLJkflLf4qPRRvW2cdzhwAWV18hsLIH
 zuFfny8Rt1/y6GuzktTS9IDkDkjWj0+Uf7OcQJAVljOzM175pJYkdQJ9ZSnygmNRHw1LFu+diKa
 YjI4+9tWNamTurE10v2euOPic+gT363iJu77mECrp6dYLlqZVBZP55AzBvRXAP1LYX2p2lPY2sj
 K7V2iy7RVOIwz7efvtw==
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 priorityscore=1501 spamscore=0 phishscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1011 adultscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604020211

Hi Ben,

> This version of the mpam missing pieces series sees a couple of things
> dropped or hidden. Memory bandwith utilization with free-running counters
> is dropped in preference of just always using 'mbm_event' mode (ABMC
> emulation) which simplifies the code and allows for, in the future,
> filtering by read/write traffic. So, for the interim, there is no memory
> bandwidth utilization support. CDP is hidden behind config expert as
> remount of resctrl fs could potentially lead to out of range PARTIDs bein=
g
> used and the fix requires a change in fs/resctrl. The setting of MPAM2_EL=
2
> (for pkvm/nvhe) is dropped as too expensive a write for not much value.
>
> There are a couple of 'fixes' at the start of the series which address
> problems in the base driver but are only user visible due to this series.
>

I tested cache occupancy and memory bandwidth allocation on a Dell PowerEdg=
e XE8712 with NVIDIA Grace A02P. Both seem to work as expected.

For the series:

Tested-by: Charles Rose <charles.rose@dell.com>

Thanks,
Charles

Internal Use - Confidential
