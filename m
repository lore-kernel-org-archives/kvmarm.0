Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF97348D869
	for <kvmarm@lists.linux.dev>; Thu,  8 Oct 2026 09:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791452744; cv=fail; b=UHMcj7q7WZC7wD7rlzTVPjZzDLAWWac97/jdjk8PMu7BfUfJNTyeWGcMJp+qYT/D1Ygwy4pgmNxpQz1RcINnZSbknJMLvbYZknIOgmnHaSjmgFQYiZjORgudLfWx7FMMr+iafB41BuB5BnQxvTonBOc5V8oODR/f925B2VO0mOo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791452744; c=relaxed/simple;
	bh=8KQsGYP83DfO02AU/JPAdG0y1UCHxBQ8+HFz0IqxU98=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=N376ttW5C5ndinloHloATqM2BIdCRpWMCEDR3rvzo57LUercxBGD2GNb1z1kblY4e7YpxDTnkzuilxiPOphdtD7FF71NHWrsTZbapF3vXH+Dm1Qfp33jI+NyK34+X1wgTIro+pnYvPk8Pc//UJrHTgyDEwFqAdb2NuAyeanASI0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=K+7gTNkJ; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=JHNsjH3B; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="K+7gTNkJ";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="JHNsjH3B"
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6987KKIv1280782;
	Thu, 8 Oct 2026 02:45:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=8KQsGYP83DfO02AU/JPAdG0y1UCHxBQ8+HFz0IqxU
	98=; b=K+7gTNkJCF4svJaW97G733H3uB5PncVoHsyzQNALXmj2awNGZHudDpAid
	oi0QnH79INjuYlcaJdqQL87lWqMTzlvo9rYiPtGA3EwPm0iFfOD3xdqPV2F7hz1z
	mbanSjSWxP9L3KXXcNi/bhZ2SgII/GDvWMxPTV2b+SYzfWmTCguI+6KqnJm/AQyL
	kqVwJ1QpFD+4INrG3eF+CPFolbWMSh0tDCljchtbcaK9KivZx2wHx0Chjw7mDn6E
	9BR1xYKnq/4r0ETl2MtYN3Jvy+vkYcH6QyZh4R6ItL6eGP6zWYT20czIylBMzKhU
	F01q9ivqRBtTwzR+zDWYkralZfkNQ==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11023128.outbound.protection.outlook.com [40.93.201.128])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4h5xe0hag1-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 08 Oct 2026 02:45:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PCnjsxx625Rdh7MIZIRiz3gO3p2Zgv39fTD2S2KfBvcpEwaAcjfs2kXFjoT2CbjKvH4AkPtVBCkQUXNffjZS9Dann3ny+oswq/U20LKnKugk6Fh1zmLyp0nwUkrFeKjf9oWtae40+3ANSMGXGmmB0Rjjj177m8eqnZbVwxaC24967bDba5Q3UsSHWc9ETBPIFbazU1OlM1RF8u9bMhTOM3cVgLgp7wD8LSesme+wROVy61Dvf9hgEbyco/vEUx7l9v6ufzbrMQdbK89cvAgj4MFw3PPXnEfCO4PYWxikQ+KIWSBcZLuRlgdtPyHRLx6YfDlB7lWulDW4w54PtikE+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8KQsGYP83DfO02AU/JPAdG0y1UCHxBQ8+HFz0IqxU98=;
 b=cTVJRiFds7rIOwsUlhxw5JtYrMlmcPohfeYffn+4Kju4FMck7zZqhsy0gryuN/JNsaD6XIROybxKGrF2IwO2Ygz/AW/m+Xt9oSg/G0YWhv1tzsUZsGfp6UaTFQOwMx0ecxBsKcgasYVe3S8m+DM3cnhRVPe/npZh8ZRDwwBVXGBV7EOjHqCjoHCtyYTZoRSnP9Qs5yFg78+8IXOyQaTWv4RXSiIMcGFZPDOuqmQSI0jVx5a/mCAO1J6dbsTCJeuPPnMa0NFnX0ZJLHO0p/lRSqmrHIhkZ+nowKkZXYjhWiQIP1Mf35jELtHPYEq/PoPTcHP6HlWG+gzf0+ueJ70ORw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8KQsGYP83DfO02AU/JPAdG0y1UCHxBQ8+HFz0IqxU98=;
 b=JHNsjH3BFZpJJ8+V/t1ibERPmuxmi7WwHzFrlsSJefqT3gKu0Shp4drr+YqTsIBcB+hfHKxXC6BPCCHhQ94kvWc0Q4X5geytNrtNCwkhLbYRDeRMuREy7B5rSQlNVTMkFPvVFyAuAWyWSJTyWLB703wsYJZvFTA+2wFReoWmnMRSC1Yb6EUmErwofFDW6fVjv8Dk0WoXaBnO353gzEQw00nUaOvaoyjXp+8Akb7mNIXxOvtEblRwVkjR7AIaxBF7kbShDrvzFCdrCYFzakuNeRY+kI/kaMk+sHwpRM7uqt7/Hy13Nrm59KukC9GnhHg1jRsczeS9Y9BzGqdVByPF/w==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DM6PR02MB055497.namprd02.prod.outlook.com (2603:10b6:5:30c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Thu, 8 Oct
 2026 09:45:07 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0496.010; Thu, 8 Oct 2026
 09:45:07 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: "eric.auger@redhat.com" <eric.auger@redhat.com>
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
        "philmd@oss.qualcomm.com"
	<philmd@oss.qualcomm.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "abologna@redhat.com"
	<abologna@redhat.com>,
        "jdenemar@redhat.com" <jdenemar@redhat.com>
Subject: Re: [PATCH v9 16/26] target/arm/kvm: Apply SYSREG props to the final
 vcpu
Thread-Topic: [PATCH v9 16/26] target/arm/kvm: Apply SYSREG props to the final
 vcpu
Thread-Index: AQHdULDbISV9iMDIKkm4nX6RrAVOHLbzUo4AgAAfa4A=
Date: Thu, 8 Oct 2026 09:45:07 +0000
Message-ID: <9E461CD6-E877-495A-BC4F-FB3AA32CB198@nutanix.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
 <20260916144721.751810-17-eric.auger@redhat.com>
 <5AC3258F-1F6E-491E-8B38-633C52199904@nutanix.com>
 <df13670e-1502-4947-8a76-600dd045708b@redhat.com>
In-Reply-To: <df13670e-1502-4947-8a76-600dd045708b@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|DM6PR02MB055497:EE_
x-ms-office365-filtering-correlation-id: 65ea49fc-75ea-49fb-3406-08df2520d647
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|38070700021|5023799004|56012099006|4143699003|10067099003|18002099003|22082099003|3023799007;
x-microsoft-antispam-message-info:
 RYHbgEn3u+KCNfMKHSw6EGwoEi8kmerVfTqK8rCdnkJW4czuuF2Oh8VxwfxNsDGNrCiv4f0ASrHk2WHiesf/7RkahMMcqbQl4j50cV9BjwanL/xA00YzrQETnCCa8SwLn0MdLKLgQMwkPeGn1md4bfxMexQur6KwhX9N6DNqbigvZzOurIH4sbt8DM7gXCD4bMRHhYlYq79rS0shHfjBm2pL9nKRO5MbX5gT2DZ8nmci2tCEpEeXnFdSmjL5jjjv3Z+JmwNbXE8WuHTJIwaH+tyucC6RGfeGkWQUnDsoxIesYLAJftFwVud1RrrRvvdnR5q8AaqgHWggNs6wLqNs/8puAFinvgUvxcb2sk2O01KRa0fM7g0ADBRKmy2JTjUb3VHK2TWXqS4784wkbiyDivaztNxzXh3ZDVwP1yXr0ugXA3BhgOqGR6HzSFh8ltmxdOPhY0pY1rVHJhKmW1wOkoo00S4KZ7PBXZ0h+vSonXebWaxSvCrqNUNW9AOmTtUiA/1dNXNyOJ2kADIckF7c9msvd6z/UEDkV5B+CAtLdjUFbtCmpU2QVWjC7sQRxVTS8cI3XQT37hO2YkAuHACxGZK8VazA9BQztZpBmP5wx+wITph0vS7HGOtsCiusIl9J7jcW2QJ3pnOC4KIJvho+4gWPPz9/32Es2oX7Vthi/K9eTOS1XebCZtbngC9xQrhUJMTGBFQn6YAW3v2w4i+2hd0r1zZ9gM35C9tP7xpWp/g=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(38070700021)(5023799004)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?c1hNUFRHMkF2M0RBRlc1YmV3OWVTdFRMdVdIb1N4Ulg4STJBVWJSa1NwNVhu?=
 =?utf-8?B?VTIveU1mdVlWRnVLUjA2RkQ3UVV1WWt0SXJkL3pqckl4MXNpSU15cHhsWDQ2?=
 =?utf-8?B?MXFhNkRDYzlPbExkMGc1elRuaDV1L2pPcTBlTnpRYjViNlVNbDNrVklxY3Rr?=
 =?utf-8?B?WElSTG5CWGZRemF4bjVvQjc0ZWY1S05OMllXc1prS3BGOE9lUjFIeDRRT083?=
 =?utf-8?B?RUNZVjRTYTJONFJjKzNOVDN4dVFWWUxOb1RDVEIzZlYvOGdpdXJyYTZlcjdP?=
 =?utf-8?B?SWRhMnMrRU1vNU9BdGl3aXlqSVVxT0pXZE1aNHJDL3NMLzMyOGgrMkt3U1kz?=
 =?utf-8?B?a0toREMrK1UzMEp6aCt0akhMRDBUaVZZUitnRkQrRUZPV1JSQjBxL2ZyOXRu?=
 =?utf-8?B?cENmR3ROa0dVS3BwdERZclhZTTJmMlBrbElFV2Q1dXROK1FrRDFNRk1Na2pz?=
 =?utf-8?B?dFc2YnZmdmI1MFM0cXN5RnBjYmc1cFk1VVFQeHpERHFuNThJeTl1cTVIL3RL?=
 =?utf-8?B?NVRuVCtEV2V4d0o4eUJHbXpIVjFnZUlUMlZhVWh6R2hhUFF4YkVCK0psMGdL?=
 =?utf-8?B?eE1aelFEbHY5SUZuTHMvZFQzUEF6ZDBrYnpPSDgzZVUzRGdaRUx3eklncVJ4?=
 =?utf-8?B?Q2UyUDJuNjB6dk9kMVNJWHRPOXV2QmpuZ2FKNmhZeEgyY2lDRDYyRG1mekEr?=
 =?utf-8?B?MWd5dEVxZWpwRFFxNDFSVTRjNFBJT0ovdjNIQVY1bmd6YU56cU1NNW9hdmZa?=
 =?utf-8?B?eU8yYmpRR1k4eEpoYkx2RE5vQjJtUHFXTzNtT2s0RFVlc3VndWE2QTY5Sm9P?=
 =?utf-8?B?ejh0SDlXRVpJTWllVkY1eG1FQ0xtc2txL3d5MzU3RnVQTEUwZ3FwWGRra1Z1?=
 =?utf-8?B?UWxKc1NqR2ZoY1BmczJBcUpWRTM3aUdyODlpdVBwVEtDc3RrajZEUEMyNVQr?=
 =?utf-8?B?VUIrK2RKbGZROXZZTUxOaDdxTnJvbzgwWGJuVmNoUnorRTVYdFdxbFNNMm9Y?=
 =?utf-8?B?WGVNd1dhZXJDVUJTK1ZUdnFoOTY4eHA2UXg2Tyt3MW9FcFNLRkx0YityQ3cz?=
 =?utf-8?B?bEVYL0tmZXgwd1MwbDJ5VXdMaHRLSkNZT3Vlb1U4UmxDclQ1RE1ROVBmb213?=
 =?utf-8?B?eUs1L1hJRHc2WWlPTDZHT3lTV01iT01DeEJ1VlB1UGN1TkhEYVZBc0g1MGV0?=
 =?utf-8?B?VGlNYngrSlFzSmVMZlNMeU5HZEVyOHNMZEU0ZVNYRjFWMnRpeVhLTG9jZWhD?=
 =?utf-8?B?MHdGeGJZRHB1ZzVqZGFFZXkySkJjZjZTQ0xYRGJ5aXdkK1JlT3FmY2hvR2dh?=
 =?utf-8?B?NGF6bEFXTVA2aUNTbHEyUks1NVowLzZzYmtIeTFaV0pvcU1abVloQ0dBYnFP?=
 =?utf-8?B?UHVYcU1raDZDME1BMmM3b0R1QnREYmZtdFRMT2VNVCtMcmY0ODdyT3NGZm4v?=
 =?utf-8?B?NVlJK2JXL21hTFlqUEkwaFlxRjlPSFBwR2FFZ3VIV3hqRHoyWGdieUdUMSsz?=
 =?utf-8?B?YzBZaS9hWENabGdTUGdQekdVbU1IYzkrUDRCZTV6dUpBYVBBdWpYZUJoRjVo?=
 =?utf-8?B?VFh2NmZMY2VzTERFQ1Q3dVkwTU5RQWtaUmdYZS9DRTZjUzVYM0xZVWZNclRo?=
 =?utf-8?B?TGhmcjd4UDV6MTlPSjBJdUt0aHhmNFhlczhQUkhMM041MWJlVGl1eUtRekVG?=
 =?utf-8?B?a2tydjhzcTRWYS9RZ0dsRVFsR0pKekhPQXV2VUU2ZERiS25ZMEFPdFdiWnN1?=
 =?utf-8?B?QjI2SzVoRVBiVTN6ZFdtMEx0RHBxaUxmaG1QV21YZndpNkhCZXhNdTZIY2h3?=
 =?utf-8?B?N1FJUHZlWFQ1VFN1ZDRzTGhvQlowdUNWdWJXUFhsdENvdXh6ZnpwOGJkaDBs?=
 =?utf-8?B?Z2txZGtkL0VSYkRhK3dtZDIveDhoYzB1cWYxakhTT1VaUHRRK3BzYXFFVUxE?=
 =?utf-8?B?M3I5cDliU2V6VmxzRjRqcFFyU3FKT1YvSHFjclN4THFiMm0wYytDTFRlelRC?=
 =?utf-8?B?aXVBOG80VThjRjA4ZW41Vk4wWmlMVTNiTU1IQlVEeFBZQ2tRaWxKWW9JQWg5?=
 =?utf-8?B?VEtTSzNTb0hUUVh1allCQ3FDL2k1WnVxZ3ZkYXdmdnY1Wk1sTWxyUnJxK2N6?=
 =?utf-8?B?NDZsRmFVaDVEdkNJd2FQWDd6KzBzbWdVYnIzRjBoUXVLUW00MXY4WlJjSEEy?=
 =?utf-8?B?dVpXV0JMNjRiZ2NPNng0anFXeGpmL2FOeHNoS0lNZ3FTSnBiQTJlM1N5NkVn?=
 =?utf-8?B?QmN6N3FmblluZkdsaEdFK3AwUlpHNXMyK3Jud0tYeWlmK3loUTZLVTVncmhG?=
 =?utf-8?B?VHJ2VmNZTzUyZ040aFlOWktyREtVOWFpVmduUjdNWU9GS2xZTmpReGg4OE80?=
 =?utf-8?Q?qtrrn3H3w/sWBREs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <68D146BEFE7CEC459C0E8D4B577406F2@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	wA+f+j5XmJqZscxAvACpgOp7TWszEgjotAA5FjTjskW451d3IUIVFEWsO3pT6wf9Ra7NCTNuTJQ1VNPrm+AWPmW1sKwNSsEKvULPbia/UOPlITIwm+/bc6yDAoXyyFy11NMBdxNzN3RJABuFfZzxZyTZ32kT8at6W/aWebx/QrRwr69oDZsp4/QU+9Af/5PalEwRdD7XWsVlTt5GmxLkjfA/t92lhMaBaWR6rDi2tMQXAfPqwPngW9AaP/dwodCxnbs6ZDERRnfViBnwJQy03wpYKDEsAUjj0CwhPo2w3CnAjD/FHWSEzBbLEtojzv2MBudPr8OBepGt8QsfBPNz+Q==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65ea49fc-75ea-49fb-3406-08df2520d647
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2026 09:45:07.4011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U3B/6juMN20OKpZNzkURwJq40hLowkIrJaHax5/MeqpNxwIJnd/0ONtYtSErpF19u3nc+fmUktqCxhcAHxjat2OYUiRDWq1b3YthWHvCE0M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB055497
X-Proofpoint-GUID: PknBCgKAoKmij1CG08Ag9-bX1uQ7NUGh
X-Proofpoint-ORIG-GUID: PknBCgKAoKmij1CG08Ag9-bX1uQ7NUGh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDAzOCBTYWx0ZWRfX094oeAKfexkW
 rmsZW6Eibn2SrC9L3bH2DWaSDISJU00xsPlEAwZ3QA5E9V0LIN/joPKWP/+JjHb1hb7BtCToOD2
 odNzB5fhZzv9jqn7y6Awsk28CiUsvNA4ilQFpe7icfQCnjMzXu2rauiEINrRDh3r2hVKb9FjSpn
 trcbNC1rSMP1bIBz9EZo+D3Gr66DNsygdeISLdYybbgxmt+IFJ/elsty2OWAJn++JVzqQnnTwQr
 GxloGltvHzGpZZgnrUwSpwfOESUn47mjBl5W3v8FZtINuwWDalYqlg5VdHlvsT5FVg8sN0TB5y7
 xHZxz51xHvb3SQPmyhrhiT4yGh5QDxqnJ8sIiTTgahLS0P2SFVV5cj3KKIVxLzppU8Tbt3wuqPo
 VzLpC2nB/vHSjTHa+56eqxnLv7FIlCjJtNeM5j8cw78JEK74J0yGMB9N57dl5ffoH49mG649NzL
 x5lUA2y1T1y/eqF4gNQ==
X-Authority-Analysis: v=2.4 cv=N4S8hG9B c=1 sm=1 tr=0 ts=6ac76626 cx=c_pps
 a=DyFIwYW+7dlM5tCrNmKnqg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=VUi8bpU7OL1Oj2-RSIOF:22 a=20KFwNOVAAAA:8
 a=2C55wLA4EEqYf_mt678A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDAzOCBTYWx0ZWRfX75GBuIe1VBXo
 seBcvxgUEL0rmPLkQ+qA4aBIid3Mf+jApVAug5KB8qRMeqMm1I7qgCXGDQbcYmIvuqlJfI0WToX
 U4C1L/0dSPH2AEb2ih2ZkrLn38l3mbI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gOCBPY3QgMjAyNiwgYXQgMToyMuKAr1BNLCBFcmljIEF1Z2VyIDxlcmljLmF1Z2Vy
QHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gIS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+ICBDQVVUSU9OOiBFeHRl
cm5hbCBFbWFpbA0KPiANCj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0hDQo+IA0KPiANCj4gDQo+IE9uIDkvMzAvMjYg
OTo1NCBBTSwgS2h1c2hpdCBTaGFoIHdyb3RlOg0KPj4gDQo+Pj4gT24gMTYgU2VwIDIwMjYsIGF0
IDg6MTXigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPiB3cm90ZToNCj4+
PiANCj4+PiAhLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLXwNCj4+PiBDQVVUSU9OOiBFeHRlcm5hbCBFbWFpbA0KPj4+IA0K
Pj4+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tIQ0KPj4+IA0KPj4+IFNZU1JFRyBwcm9wIHNldHRpbmdzIHdlcmUgcmVj
b3JkZWQgaW4gYSBoYXNodGFibGUgYnV0IHRoZXkNCj4+PiBhcmUgbm90IHlldCBpbmplY3RlZCBv
biBndWVzdC4gSXRlcmF0ZSBvdmVyIGFsbCBzZXQgZmllbGRzIGFuZA0KPj4+IGFwcGx5IHRoZSBu
ZXcgdmFsdWUgdGhyb3VnaCBLVk1fU0VUX09ORV9SRUcuIFRoZSBuZXcgZmllbGQNCj4+PiB2YWx1
ZSBvdmVycmlkZXMgdGhlIGN1cnJlbnQgb2JzZXJ2YWJsZSB2Y3B1IHJlZ2lzdGVyIHZhbHVlLg0K
Pj4+IA0KPj4+IFNpZ25lZC1vZmYtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNv
bT4NCj4+PiAtLS0NCj4+PiB0YXJnZXQvYXJtL2t2bS5jICAgICAgICB8IDY1ICsrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+Pj4gdGFyZ2V0L2FybS90cmFjZS1ldmVu
dHMgfCAgMSArDQo+Pj4gMiBmaWxlcyBjaGFuZ2VkLCA2NiBpbnNlcnRpb25zKCspDQo+Pj4gDQo+
Pj4gZGlmZiAtLWdpdCBhL3RhcmdldC9hcm0va3ZtLmMgYi90YXJnZXQvYXJtL2t2bS5jDQo+Pj4g
aW5kZXggM2VjMjYxOGNjMS4uZGRmMzIwZDBlNiAxMDA2NDQNCj4+PiAtLS0gYS90YXJnZXQvYXJt
L2t2bS5jDQo+Pj4gKysrIGIvdGFyZ2V0L2FybS9rdm0uYw0KPj4+IEBAIC0zNDMsNiArMzQzLDkg
QEAgc3RhdGljIEFSTTY0U3lzUmVnRmllbGQgKmdldF9maWVsZChpbnQgaSwgQVJNNjRTeXNSZWcg
KnJlZykNCj4+PiAjZGVmaW5lIE1BS0VfSURSRUdfS0VZKHJlZ19pZHgsIGZpZWxkX3NoaWZ0KSBc
DQo+Pj4gICAgKCgodWludDY0X3QpKHJlZ19pZHgpIDw8IDgpIHwgKCh1aW50NjRfdCkoZmllbGRf
c2hpZnQpICYgMHhGRikpDQo+Pj4gDQo+Pj4gKyNkZWZpbmUgS0VZX1RPX1JFR19JRFgoa2V5KSAg
ICAgKCh1aW50MzJfdCkoKCh1aW50NjRfdCkoa2V5KSkgPj4gOCkpDQo+Pj4gKyNkZWZpbmUgS0VZ
X1RPX1NISUZUKGtleSkgICAgICAgKCh1aW50OF90KSgoKHVpbnQ2NF90KShrZXkpKSAmIDB4RkYp
KQ0KPj4+ICsNCj4+PiBzdGF0aWMgdm9pZCBzZXRfc3lzcmVnX3Byb3AoT2JqZWN0ICpvYmosIFZp
c2l0b3IgKnYsDQo+Pj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc3QgY2hhciAqbmFt
ZSwgdm9pZCAqb3BhcXVlLA0KPj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgIEVycm9yICoq
ZXJycCkNCj4+PiBAQCAtMjIxNSw2ICsyMjE4LDYzIEBAIGludCBrdm1fYXJjaF9wcmVfY3JlYXRl
X3ZjcHUoQ1BVU3RhdGUgKmNwdSwgRXJyb3IgKiplcnJwKQ0KPj4+ICAgIHJldHVybiAwOw0KPj4+
IH0NCj4+PiANCj4+PiArc3RhdGljIGludCBrdm1fYXJtX2FwcGx5X3N5c3JlZ19wcm9wcyhBUk1D
UFUgKmNwdSwgRXJyb3IgKiplcnJwKQ0KPj4+ICt7DQo+Pj4gKyAgICB1aW50NjRfdCAqaWRyZWdz
ID0gY3B1LT5pc2FyLmlkcmVnczsNCj4+PiArICAgIGdwb2ludGVyIGtleV9wdHIsIHZhbHVlX3B0
cjsNCj4+PiArICAgIENQVVN0YXRlICpjcyA9IENQVShjcHUpOw0KPj4+ICsgICAgR0hhc2hUYWJs
ZUl0ZXIgaXRlcjsNCj4+PiArDQo+Pj4gKyAgICBnX2hhc2hfdGFibGVfaXRlcl9pbml0KCZpdGVy
LCBjcHUtPnN5c3JlZ19wcm9wcyk7DQo+Pj4gKw0KPj4+ICsgICAgd2hpbGUgKGdfaGFzaF90YWJs
ZV9pdGVyX25leHQoJml0ZXIsICZrZXlfcHRyLCAmdmFsdWVfcHRyKSkgew0KPj4+ICsgICAgICAg
IHVpbnQ2NF90IGtleSA9ICh1aW50NjRfdClrZXlfcHRyOw0KPj4+ICsgICAgICAgIHVpbnQ2NF90
IHZhbHVlID0gKHVpbnQ2NF90KXZhbHVlX3B0cjsNCj4+PiArICAgICAgICB1aW50MzJfdCByZWdf
aWR4ID0gS0VZX1RPX1JFR19JRFgoa2V5KTsNCj4+PiArICAgICAgICB1aW50OF90IGxvd2VyICAg
ID0gS0VZX1RPX1NISUZUKGtleSk7DQo+Pj4gKyAgICAgICAgQVJNNjRTeXNSZWcgKnJlZyA9ICZh
cm02NF9pZF9yZWdzW3JlZ19pZHhdOw0KPj4+ICsgICAgICAgIHN0cnVjdCBrdm1fb25lX3JlZyBr
dm1fcmVnOw0KPj4+ICsgICAgICAgIHVpbnQ2NF90IGN1cnJlbnQsIG9sZCwgbWFzazsNCj4+PiAr
ICAgICAgICB1aW50NjRfdCBrdm1faWR4Ow0KPj4+ICsgICAgICAgIEFSTTY0U3lzUmVnRmllbGQg
KmZpZWxkID0gZ2V0X2ZpZWxkKGxvd2VyLCByZWcpOw0KPj4+ICsgICAgICAgIGludCBsZW5ndGgg
PSBmaWVsZC0+bGVuZ3RoOw0KPj4+ICsgICAgICAgIHVpbnQ2NF90IG9sZGZ2Ow0KPj4+ICsgICAg
ICAgIGludCByZXQ7DQo+Pj4gKw0KPj4+ICsgICAgICAgIG1hc2sgPSBNQUtFXzY0QklUX01BU0so
bG93ZXIsIGxlbmd0aCk7DQo+Pj4gKyAgICAgICAgdmFsdWUgPSB2YWx1ZSA8PCBsb3dlcjsNCj4+
PiArDQo+Pj4gKyAgICAgICAgb2xkID0gaWRyZWdzW3JlZ19pZHhdOw0KPj4+ICsNCj4+PiArICAg
ICAgICBrdm1faWR4ID0gaWRyZWdzX3N5c3JlZ190b19rdm1fcmVnKGlkX3JlZ2lzdGVyX3N5c3Jl
Z1tyZWdfaWR4XSk7DQo+Pj4gKyAgICAgICAgcmV0ID0gcmVhZF9zeXNfcmVnNjQoY3MtPmt2bV9m
ZCwgJmN1cnJlbnQsIGt2bV9pZHgpOw0KPj4+ICsgICAgICAgIGlmIChyZXQpIHsNCj4+PiArICAg
ICAgICAgICAgZXJyb3Jfc2V0ZyhlcnJwLCAiZmFpbGVkIHRvIHJlYWQgdGhlIGN1cnJlbnQgdmFs
dWUgb2YgJXMiLA0KPj4+ICsgICAgICAgICAgICAgICAgICAgICAgIHJlZy0+bmFtZSk7DQo+Pj4g
KyAgICAgICAgICAgIHJldHVybiByZXQ7DQo+Pj4gKyAgICAgICAgfQ0KPj4+ICsgICAgICAgIG9s
ZGZ2ID0gKGN1cnJlbnQgJiBtYXNrKSA+PiBsb3dlcjsNCj4+PiArDQo+Pj4gKyAgICAgICAgaWRy
ZWdzW3JlZ19pZHhdID0gY3VycmVudCAmIH5tYXNrOw0KPj4+ICsgICAgICAgIGlkcmVnc1tyZWdf
aWR4XSB8PSB2YWx1ZTsNCj4+PiArDQo+Pj4gKyAgICAgICAga3ZtX3JlZy5pZCA9IGt2bV9pZHg7
DQo+Pj4gKyAgICAgICAga3ZtX3JlZy5hZGRyID0gKHVpbnRwdHJfdCkmaWRyZWdzW3JlZ19pZHhd
Ow0KPj4+ICsNCj4+PiArICAgICAgICByZXQgPSBpb2N0bChjcy0+a3ZtX2ZkLCBLVk1fU0VUX09O
RV9SRUcsICZrdm1fcmVnKTsNCj4+PiArICAgICAgICBpZiAocmV0KSB7DQo+Pj4gKyAgICAgICAg
ICAgIGVycm9yX3NldGcoZXJycCwgImZhaWxlZCB0byBhcHBseSBuZXcgdmFsdWUgMHglIlBSSXg2
NCIgZm9yIGZpZWxkICVzLiVzICINCj4+PiArICAgICAgICAgICAgICAgICAgICAgICAiKHByZXZp
b3VzIGlzIDB4JSJQUkl4NjQiKTogJW0iLCBpZHJlZ3NbcmVnX2lkeF0sDQo+Pj4gKyAgICAgICAg
ICAgICAgICAgICAgICAgcmVnLT5uYW1lLCBmaWVsZC0+bmFtZSwgb2xkZnYpOw0KPj4+ICsgICAg
ICAgICAgICByZXR1cm4gcmV0Ow0KPj4+ICsgICAgICAgIH0NCj4+IEhpIEVyaWMsDQo+PiANCj4+
IFRoZSBhYm92ZSBpcyB0aGUgb25seSBLVk0tcmVsYXRlZCBjb2RlIGhlcmUuIENhbiB3ZSBzcGxp
dCB0aGlzIGludG8NCj4+ICAgIDEuIEFwcGx5IFNZU1JFR18gcHJvcHMgY2FsbGJhY2sgd2hpY2gg
cmVzaWRlcyBpbiBjcHU2NC5jPw0KPj4gICAgMi4gVGhlIHByZXZpb3VzIHdyaXRlYmFjayB0byBj
cHJlZ3MgZnVuY3Rpb24gdGhhdCB3cml0ZXMgYmFjayBJRCByZWdpc3RlcnMgdG8gS1ZNPw0KPiAN
Cj4gdGhlIHByb2JsZW0gaXMgdGhlIHByZXZpb3VzIG1ldGhvZCB3YXMgY29weWluZyBhbGwgdGhl
IGlkcmVncyB0aGF0DQo+IGNoYW5nZWQgYmFjayB0byBjcHJlZ3MuIEJ1dCB0aG9zZSBpZHJlZ3Mg
d2VyZSBwb3B1bGF0ZWQgZnJvbSB0aGUgIm1heCINCj4gdmNwdSB3aGljaCBpbiBzb21lIGNhc2Vz
IGxlZCB0byBpbmNvbnNpc3RlbmN5IHdpdGggdGhlIGZpbmFsIHZjcHUNCj4gc2V0dGluZy4gVGhl
IHNldHRlciBub3cgcmVnaXN0ZXJzIHRoZSBuZXcgZmllbGQgdmFsdWUgaW4gYSBoYXNoIHRhYmxl
Lg0KPiBNYXliZSB3ZSBjYW4ganVzdCByZWx5IG9uIGFuIGFyY2ggY2FsbGJhY2sgdG8gYXBwbHkg
dGhlbSBvbiB0aGUgZ3Vlc3QNCj4gDQpZZXMsIHRoaXMgaXMgd2hhdCBJIGFtIHN1Z2dlc3Rpbmcu
DQoNCldoYXQgSSB3YXMgdGhpbmtpbmcgaXMgYSBLVk0tc3BlY2lmaWMgY29kZSAoa3ZtX2FyY2hf
aW5pdF92Y3B1KSB3aWxsIGNhbGwgY2FsbGJhY2sgdG8gY3B1NjQuYyB0byBzZXQgdGhlIHByb3Bl
cnR5IHZhbHVlcyBhZnRlciB0aGUgdkNQVXMgYXJlIGluaXQsIGFuZCBhZnRlciB0aGUgY2FsbGJh
Y2sgZmluaXNoZXMsIHRoZSB2YWx1ZXMgYXJlIHdyaXR0ZW4gYmFjayB0byBjcHJlZ3MuDQoNCldp
dGggdGhpcyB0aGUgaW5jb25zaXN0ZW5jeSBwcm9ibGVtIGRvZXMgbm90IGFyaXNlIGFzIHdlIHdp
bGwgb25seSBjYWxsIHRoZSBjYWxsYmFjayBhZnRlciB3ZSBwcm9wZXJseSBzZXR1cCB0aGUgdkNQ
VS4NCg0KRldJVSwgeW91IGFyZSBzdWdnZXN0aW5nIHRoZSBzYW1lIHRoaW5nPw0KDQpUaGFua3Ms
DQpLaHVzaGl0DQo+IFRoYW5rcw0KPiANCj4gRXJpYw0KPj4gDQo+PiBUaGUgcmVhc29uIGJlaW5n
IHRoZSBTWVNSRUdfIHByb3BzIG90aGVyd2lzZSBkbyBub3Qgd29yayB3aXRoIGFueSBvdGhlciBh
Y2NlbGVyYXRvci4NCj4+IFdlIGFyZSBhbHJlYWR5IHRyeWluZyB0byBtYWtlIHRoZSBTWVNSRUdf
IGdldHRlci9zZXR0ZXIgYWNjZWwtYWdub3N0aWMuDQo+PiANCj4+IFRoZSBhYm92ZSBtZXRob2Qg
c3RpbGwgaGFzIHRoZSBuaWNldHkgdGhhdCAtY3B1IGhvc3Qgd2l0aG91dCBhbnkgU1lTUkVHXyBw
cm9wIHNob3VsZA0KPj4gYmVoYXZlIHRoZSBzYW1lIGFzIHByZXZpb3VzIDopDQo+PiANCj4+IFNp
ZGUgbm90ZToNCj4+IFdoaWxlIHdlIGRvbuKAmXQgdGFyZ2V0IFRDRyBzdXBwb3J0IGN1cnJlbnRs
eSwgSSB0cmllZCB5b3VyIHY4ICsgbmFtZWQgbW9kZWxzIG9uIFRDRw0KPj4gKHF1aWNrIGhhY2s7
IH4yMCBMT0MpLCBhbmQgU1lTUkVHXyBwcm9wcy9uYW1lZCBtb2RlbHMgd29ya3MgYWxtb3N0IG91
dCBvZiB0aGUgYm94DQo+PiB0aGVyZSAodmVyeSBtaW5pbWFsIHRlc3RpbmcpLCB3aGljaCB3YXMg
Y29vbC4NCj4+IA0KPj4gVGhhbmtzLA0KPj4gS2h1c2hpdA0KPj4gDQo+Pj4gKw0KPj4+ICsgICAg
ICAgIHRyYWNlX2FwcGx5X3N5c3JlZ19wcm9wKHJlZy0+bmFtZSwgZmllbGQtPm5hbWUsIG9sZCwg
Y3VycmVudCwNCj4+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBtYXNrLCB2YWx1
ZSwgaWRyZWdzW3JlZ19pZHhdKTsNCj4+PiArICAgIH0NCj4+PiArICAgIHJldHVybiAwOw0KPj4+
ICt9DQo+Pj4gKw0KPj4+IGludCBrdm1fYXJjaF9pbml0X3ZjcHUoQ1BVU3RhdGUgKmNzLCBFcnJv
ciAqKmVycnApDQo+Pj4gew0KPj4+ICAgIGludCByZXQ7DQo+Pj4gQEAgLTIzMTUsNiArMjM3NSwx
MSBAQCBpbnQga3ZtX2FyY2hfaW5pdF92Y3B1KENQVVN0YXRlICpjcywgRXJyb3IgKiplcnJwKQ0K
Pj4+ICAgIH0NCj4+PiAgICBjcHUtPm1wX2FmZmluaXR5ID0gbXBpZHIgJiBBUk02NF9BRkZJTklU
WV9NQVNLOw0KPj4+IA0KPj4+ICsgICAgcmV0ID0ga3ZtX2FybV9hcHBseV9zeXNyZWdfcHJvcHMo
Y3B1LCBlcnJwKTsNCj4+PiArICAgIGlmIChyZXQpIHsNCj4+PiArICAgICAgICByZXR1cm4gcmV0
Ow0KPj4+ICsgICAgfQ0KPj4+ICsNCj4+PiAgICByZXR1cm4ga3ZtX2FybV9pbml0X2NwcmVnX2xp
c3QoY3B1KTsNCj4+PiB9DQo+Pj4gDQo+Pj4gZGlmZiAtLWdpdCBhL3RhcmdldC9hcm0vdHJhY2Ut
ZXZlbnRzIGIvdGFyZ2V0L2FybS90cmFjZS1ldmVudHMNCj4+PiBpbmRleCBkNzJhZDZiNjcxLi5i
NGQyYjQ1YTdkIDEwMDY0NA0KPj4+IC0tLSBhL3RhcmdldC9hcm0vdHJhY2UtZXZlbnRzDQo+Pj4g
KysrIGIvdGFyZ2V0L2FybS90cmFjZS1ldmVudHMNCj4+PiBAQCAtMTgsNiArMTgsNyBAQCBrdm1f
YXJtX3dyaXRhYmxlX2lkcmVnc190b19jcHJlZ19saXN0KGNvbnN0IGNoYXIgKm5hbWUsIHVpbnQ2
NF90IHByZXZpb3VzLCB1aW50Ng0KPj4+IGRlY29kZV9pZHJlZ193cml0ZW1hcChjb25zdCBjaGFy
KiBuYW1lLCBpbnQgbG93ZXIsIGludCB1cHBlciwgY2hhciAqcHJvcF9uYW1lKSAiJXMgWyVkOiVk
XSBpcyB3cml0YWJsZSAocHJvcCAlcykiDQo+Pj4gZ2V0X3N5c3JlZ19wcm9wKGNvbnN0IGNoYXIg
Km5hbWUsIHVpbnQ2NF90IHZhbHVlKSAiJXMgMHglIlBSSXg2NA0KPj4+IHNldF9zeXNyZWdfcHJv
cChjb25zdCBjaGFyICpuYW1lLCB1aW50NjRfdCBvbGQsIHVpbnQ2NF90IG1hc2ssIHVpbnQ2NF90
IGZpZWxkX3ZhbHVlLCB1aW50NjRfdCBuZXcpICIlcyBvbGQgcmVnIHZhbHVlPTB4JSJQUkl4NjQi
IG1hc2s9MHglIlBSSXg2NCIgbmV3IGZpZWxkIHZhbHVlPTB4JSJQUkl4NjQiIG5ldyByZWcgdmFs
dWU9MHglIlBSSXg2NA0KPj4+ICthcHBseV9zeXNyZWdfcHJvcChjb25zdCBjaGFyICpyZWdfbmFt
ZSwgY29uc3QgY2hhciAqZmllbGRfbmFtZSwgdWludDY0X3Qgb2xkLCB1aW50NjRfdCBjdXJyZW50
LCB1aW50NjRfdCBtYXNrLCB1aW50NjRfdCBmaWVsZF92YWx1ZSwgdWludDY0X3QgbmV3KSAiJXMu
JXMgb2xkPTB4JSJQUkl4NjQiIGN1cnJlbnQ9MHglIlBSSXg2NCIgbWFzaz0weCUiUFJJeDY0IiBu
ZXcgZmllbGQgdmFsdWU9MHglIlBSSXg2NCIgbmV3PTB4JSJQUkl4NjQNCj4+PiBuYl9zeXNyZWdf
cHJvcHMoY29uc3QgY2hhciAqbmFtZSwgaW50IGNvdW50KSAiJXM6ICVkIFNZU1JFRyBwcm9wZXJ0
aWVzIg0KPj4+IA0KPj4+ICMgY3B1LmMNCj4+PiAtLSANCj4+PiAyLjUzLjANCg0KDQo=
