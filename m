Received: from TY3P286CU002.outbound.protection.outlook.com (mail-japaneastazon11010049.outbound.protection.outlook.com [52.101.229.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5964B9E75
	for <kvmarm@lists.linux.dev>; Thu,  8 Jan 2026 10:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.229.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767868594; cv=fail; b=EXYhwS/vmAvmx3vdL+rvKUjpEtfFsTcaoUnxeBdN0K3kOTQ2sPHHjHBJXNGYcyaxkJFvOS3RoVIpErMnqcE98p5IFYHdxOz6W6c5peNWKtZfaqyjO285k+UFc8fwmj73EOQP3pstMf/OGDI+7pE2o00KIF1dRP4Y7WC+N7Jb4Tk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767868594; c=relaxed/simple;
	bh=jOxQH/hW6U8jDtFkRK3KAXgK45+hryPxw7J/OyzWUOc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S38mfX14y+4eDhW+lkQ4n5WLF0DNrzNdGUZLok2QfRMlXeBVW/dBf2mA6DymUF5EiSkeBQW/kU96It3qP5qMIB1WJD5O/fs5a+6RYa4ThoNvut+99MpjhPo1fLZa27E2Me/DdR2bqTx4IAPo2k3QMvH1jFNzJ+1yBe2kDAlyCMA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=W1gHAXvy; arc=fail smtp.client-ip=52.101.229.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="W1gHAXvy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UPxN96i1wvdxcy68lVvxnjjdrs1eBZ5KQDHXgzU3kS/DFWxMUHZ7rKETXJqPVR+jCRjzIwVBo9DR2bXottsOgW+wX46FuzMi4OFOROkeljSbYG8Ban8oUcXmbFhvJFpYaRidfwm+4poCr83/PR2n7xk+pV8Fmm5wJp9pnY/pTNH+Ghdhk8iXKftZZLDEgI/U4nAhEJ+HbEFE6HujtZkcA6/oe8hoYlT5+2xm080V3okYn8TOAvpQjTp6QzBe1pebZVaWHqvQPnHcqQB76H99Jrbot5Z8oxL8xpOz1Lg/8R45ci4YzrnSPY2+MRy13YtriV3Ch6PgOkIVap9yJEXKaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3OHD/t8ihQZNvz1JnfdQoqaFGYAC7Yw3mNrQOagNk8c=;
 b=s0wIS1xk+9LTdEgo1CHquK/NVSJwwgOdFe04DJKexxRAsH9M2DQdCczzZwVqLwUeqvWsiAZS9+Z3aKEy3QLcfmZjYhDcCWpED2CKmp8uOQ8hUHPQ7EMaMezc50/zSmrZsBTPCnS6M7/6Q9jHB71XLdb/w2tVBDrWNnSug5m6BBnq6WtpSJsb49I9prSSfaaq3hXECreSVI1ICdY05VZ34x6ZZZpMiU+28pcxptgHnp2W5cYW3zL9zmAOIlmGSEulzSgZfl2XdfUBpj5xKO5vUdtzK7wo3OTg4TmBdA/Vy35ECM4U7uRb15HJki9wa7X68yMGCmhtEOYBTGmIiU62Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3OHD/t8ihQZNvz1JnfdQoqaFGYAC7Yw3mNrQOagNk8c=;
 b=W1gHAXvy18XHaJJAQqwy8pYIKgqhzh+2MD8KMVZ7GtLU1WycjSRoTcU2VWKyjz9DRfP7Koe97sNlTmKaghtv7ZXlk+6zYGvz0lTnmnrFWwfGX22uJo3OTUD6EqaudI7PJ4x+kf6w7eyy91SBW7etfxAWVsK7wOrFeW/aMFzFd4VgSFUFXPlJkf+O4yvUSqYmZxFBo/vpVY964HymgaHy53uZK7ZZCVtRMDQbqOTkWCOQG7LpOlvkKakg8RtLbSPA38Uhfag/NMBHNxbaqO9u1VnTZtg7TlvZHtx6HaPirLf0fmI2Z3fkW8fxo/KIER6tj1pIbreLaKt9z9lODrEJTA==
Received: from OSZPR01MB8798.jpnprd01.prod.outlook.com (2603:1096:604:15f::6)
 by TY4PR01MB15081.jpnprd01.prod.outlook.com (2603:1096:405:280::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.0; Thu, 8 Jan
 2026 10:36:23 +0000
Received: from OSZPR01MB8798.jpnprd01.prod.outlook.com
 ([fe80::e366:d390:4474:8cfa]) by OSZPR01MB8798.jpnprd01.prod.outlook.com
 ([fe80::e366:d390:4474:8cfa%6]) with mapi id 15.20.9520.001; Thu, 8 Jan 2026
 10:36:23 +0000
From: "Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>
To: Ben Horgan <ben.horgan@arm.com>
CC: "amitsinght@marvell.com" <amitsinght@marvell.com>,
	"baisheng.gao@unisoc.com" <baisheng.gao@unisoc.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"carl@os.amperecomputing.com" <carl@os.amperecomputing.com>,
	"dave.martin@arm.com" <dave.martin@arm.com>, "david@kernel.org"
	<david@kernel.org>, "dfustini@baylibre.com" <dfustini@baylibre.com>,
	"fenghuay@nvidia.com" <fenghuay@nvidia.com>, "gshan@redhat.com"
	<gshan@redhat.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
	"kobak@nvidia.com" <kobak@nvidia.com>, "lcherian@marvell.com"
	<lcherian@marvell.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "peternewman@google.com"
	<peternewman@google.com>, "punit.agrawal@oss.qualcomm.com"
	<punit.agrawal@oss.qualcomm.com>, "quic_jiles@quicinc.com"
	<quic_jiles@quicinc.com>, "reinette.chatre@intel.com"
	<reinette.chatre@intel.com>, "rohit.mathew@arm.com" <rohit.mathew@arm.com>,
	"scott@os.amperecomputing.com" <scott@os.amperecomputing.com>,
	"sdonthineni@nvidia.com" <sdonthineni@nvidia.com>, "xhao@linux.alibaba.com"
	<xhao@linux.alibaba.com>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
	"corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, "joey.gouly@arm.com"
	<joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Subject: Re: [PATCH v2 15/45] arm_mpam: resctrl: Add boilerplate cpuhp and
 domain allocation
Thread-Topic: [PATCH v2 15/45] arm_mpam: resctrl: Add boilerplate cpuhp and
 domain allocation
Thread-Index: AQHccRMn7c+o73u4aUCvPsv+3kydzbVIMtqA
Date: Thu, 8 Jan 2026 10:36:23 +0000
Message-ID:
 <OSZPR01MB87980D7660524C1FF389A4518B85A@OSZPR01MB8798.jpnprd01.prod.outlook.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
 <20251219181147.3404071-16-ben.horgan@arm.com>
In-Reply-To: <20251219181147.3404071-16-ben.horgan@arm.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=True;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2026-01-08T10:36:23.088Z;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=1;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OSZPR01MB8798:EE_|TY4PR01MB15081:EE_
x-ms-office365-filtering-correlation-id: 7acfe88a-6bf7-433c-6749-08de4ea1c4fc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|366016|376014|38070700021|1580799027;
x-microsoft-antispam-message-info:
 =?iso-2022-jp?B?Mk5zQ1p6amdNZFBqMGdkNGhQMXoxWE1GSkNuaFc4SlRNaFo1bnR0Vmt2?=
 =?iso-2022-jp?B?cjJDYXp0eTRncXJ4UUMwSUhNOU9HUkJsZSt4cjV3RjFyTXVkWUVmWFpu?=
 =?iso-2022-jp?B?ZjQvRzJmZStZem5LTEZhTWlwdlJMNVp6SmlQbmZIemVlRVhwQ1VpR005?=
 =?iso-2022-jp?B?clhHSVBYSldvWXRZY2d4RGhweDdGTW9hTWZMNTROZllmc2tGQTUxUkFr?=
 =?iso-2022-jp?B?d2VCMDN6UmlreHVUd21URDM2TFVVVUhOcE1CcEIya0JRaWFuUlgzeXRJ?=
 =?iso-2022-jp?B?Y0h3bStxVGp4K2g5N3NJL053UHp5M0hLbUlVM2hxMllJR3hiTFBVR2w2?=
 =?iso-2022-jp?B?Zk5CcjdxeEx1c1ovR1UvN3lQTnBUN24vWW9kVFkxNzRhamlyMWxRTzVY?=
 =?iso-2022-jp?B?Y3BBZVNJQnNlK1VwakhFaDZhTVpVMFVOZEFSK2UzL3dLUXdyTWZEdzlV?=
 =?iso-2022-jp?B?Uy9NRGNlYm1kTG1IU0NzbDJtMXRWckIxbEpQd1VsTTBIRStlc2xaQ21t?=
 =?iso-2022-jp?B?K2ZaOVVKYmRNa3d3YlVhWDY4TS9SR2JNZzZNSEREZTdXeXQxeWxncU4w?=
 =?iso-2022-jp?B?UDRlV05XZ011dXY1M3N0VG9DKzVCMWl1cDR3RTV3dFlLR3lUSC9CVUdl?=
 =?iso-2022-jp?B?d3E1elZ1VFZlVW1VeVdHenZtMTE1dTZSTU1iYzYwR2Q1UjhxTDhmK3ZU?=
 =?iso-2022-jp?B?cnpaOG1EMnIvNzJYQlFFN0hibUFNcVV2VGc2akQzSkM4TjllUVAycC9D?=
 =?iso-2022-jp?B?cWJyNmxPYWlBZUk0c1BwbnFxUjVUc21MVUhZUkh0NDViTEtTZGkxNm1U?=
 =?iso-2022-jp?B?N0ZIRmhlNDhtaWhtK0taU05UVThYcjlZTm1oR3lldm9lTnBKRExYdXJk?=
 =?iso-2022-jp?B?bnFob2ZUMmZrK1NMSDRtc2J1aktseGRTL0VZK2NuSE0zZkpnbUJRcmpt?=
 =?iso-2022-jp?B?MWJ4Wk1tYUZZV0dKVXdyR0JtbTlaaEZPZG05dEVwRG1yT3BIakNDZG5H?=
 =?iso-2022-jp?B?ZXZOR3diZnAvY2FwM0R1ZkVrQkpiNXhLQ2krajdXSGkweUNnSW5IaDgw?=
 =?iso-2022-jp?B?aEhXc0FJRWV1bDhFQ3IxZnpldTVNaFhzY3VTb0xwVDJ3OWF0N1NER2ZR?=
 =?iso-2022-jp?B?M0xsQUVtRTBwRndnOXFWMjc5OGkzUVhsNjdnSTZsMGxET3FQeDY1VzdC?=
 =?iso-2022-jp?B?RURGUk8zZFRpR1ZYWWlJemIzUFJwTm9oem0yZk0zMWdTNytGMTdvODB4?=
 =?iso-2022-jp?B?NWJLUXQxUEg5QWZIRHhLYmlvU1BXMzU5dGsvVWs4MkYzV0JZT2ZvMytM?=
 =?iso-2022-jp?B?Wkdna010RkxGNCtmQU42RVBQbTR3SEhSSUR0SHBUSHlmeC8xMk81aEx2?=
 =?iso-2022-jp?B?SUQ1L25VU1MzQ3h1VENpVkVaWHEvQnFmYytsenBEMzVQZFppUUJjTFox?=
 =?iso-2022-jp?B?THpXaTd0R0tYWnEyL0dvV3dQNmI3U2h1czUvWGpoZ1BSYkk3RGlXNkdj?=
 =?iso-2022-jp?B?RUFuZEZpVkJ0eHE1Z01zSG5XcXpQUHlWM05TNWgxM3g3STR2ZGRQZ1dk?=
 =?iso-2022-jp?B?enRjYm9hcVBzQkJNKzlBZXRSODJJbzNlc3JJc2lWVTNBYld1UU1mekRx?=
 =?iso-2022-jp?B?K2hyNmQ1dkxCTWJQV0lCbzBSMUNuZWZlOXRWcGZKdXRnSnFCVzBVNmw5?=
 =?iso-2022-jp?B?VnF5cGhVLzhsMTVqWHViVTBHcE1aOXR4UGdiWHVaNUJiYms4Y1h5UDZi?=
 =?iso-2022-jp?B?Q0xVdDRJaHdveElMelpsN2dCTmc2a2MwVWIveEZoYm9QdmpWYWlTUlRH?=
 =?iso-2022-jp?B?SVdZeDhNdnBoK2MyYTA2UUprZjdVaWFGckVPZDR0ZlZwcFp2YmtjbFhh?=
 =?iso-2022-jp?B?bXlmUjNYODlwRVJGVU1mZEVMZ3J6MjdiMkxhaUliS3B3MXlFZ2lWOGEz?=
 =?iso-2022-jp?B?b04rV28wRm9YbHRNM094M2phb3U0TGVQcnA2b05OaXBvaThjeXBRbVhN?=
 =?iso-2022-jp?B?WE5SSnRhYmFDVGFvWVkzWDhucVcvS2xZZUZjZHdUeGtVbThiWExtRldB?=
 =?iso-2022-jp?B?MFFMM0s5NFJXWVhkWWt3MEJBYlhOZy9tQjJjNWV0N2FCZ0VLcWJZTWQ5?=
 =?iso-2022-jp?B?Ri82S0UwNi9JbnpWNkUyN0diN2hGbEtTNThaRnFwT1U3aFI3N3oxOEtP?=
 =?iso-2022-jp?B?a0JEZjlsUGVIaWJJQ2Z0WXVkektacUdXcEtweWs3c1hRa25NbDlXYzBi?=
 =?iso-2022-jp?B?bElxdz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB8798.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(38070700021)(1580799027);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?QnNHMWppSTF4MDJ4YnNYYVgvekE2OUJnNGJ2TUl4d0JaSHBETDVCYTBs?=
 =?iso-2022-jp?B?SS80SjFhQ0VJeG1ZaExjZlJvcEdGcWlzWXlRSzc2cE1hVmRtNlZQOVh4?=
 =?iso-2022-jp?B?R3htUU9tOHZCa01FUVlvRVU5MjM5TzJVZjVZOFAzdWhOaWxObWFJUHVO?=
 =?iso-2022-jp?B?eGFTdDNuSHNVeFc4SElSTG1EVDJiNFFwL2RPM3NIQnlyTExxak1mTEJt?=
 =?iso-2022-jp?B?SjZOVGdOUkJ5VjdteURXWEo0aVdlblU2bURTNTJuQWY2QzNlYnV0L1I2?=
 =?iso-2022-jp?B?OGFqZ28vYW94aW90RlNNak5yME9tdytiOGNIWUVxNHk1WlYvOUYxbm84?=
 =?iso-2022-jp?B?QThrL3ZpZWUvUWVZUEsxSDhYR09tZXBiZGlWSUk4L0NTbTJMZDNNU1Q3?=
 =?iso-2022-jp?B?bE5TOXl2NTdXRU9hdFN4OEdENHR1YXByQ0dXUU03T3gyeXBSUVAyVlNy?=
 =?iso-2022-jp?B?ajRzbXpJZzY1WEY1K0Y0bURXdnZiaG53OEViOVRvV1VZYW5iUE5NQ1E0?=
 =?iso-2022-jp?B?dTJEc1VBUitWVzFFeWc4MFVXT3FPSE80TGZnbHY5a0VRMjZlQlRFWnBM?=
 =?iso-2022-jp?B?dldnWmw3Z0ZKQ1lZbEpqMVBzRmJpdjVaNUw0RkpGSGsyeXdwVjFOUTdz?=
 =?iso-2022-jp?B?ZnBjTlhPZHk0R2lJeDd3alpPallZak5Sd1YxVkt6RlJyOWx1ZHloek00?=
 =?iso-2022-jp?B?M1NHYzdzcGNKOUVhQmt1VVlOd21wSEVoRzYrdGRHamlMSVhodnVwZ1JI?=
 =?iso-2022-jp?B?V0ZSdEo2eUk5N0FBR1VYQkJ0Skd5RnY3TlExN0ZQY3BCcEVkUlVLMlRh?=
 =?iso-2022-jp?B?ZDhpY3lVQzkvM1FLSjQrTzRwRmhBdEI4cjNKZ0Z6NzJHQ0xzWWpzelpp?=
 =?iso-2022-jp?B?b0MyaEZtdlRoTzRJV1htQlVlTGtvSURrUGhXamFXTFBoVEg5Qnh1Q3py?=
 =?iso-2022-jp?B?eHhxSVFSSUM5SE1qaHIwQUZvbVVhdFZVcU8rQjB6Q2hCTDY2bmFTaUlQ?=
 =?iso-2022-jp?B?ZFoxRGpMZWZoOGppVjFNaWsxMVVCOS9ZSEpKOFl1bnljUGNScTdXV0Iz?=
 =?iso-2022-jp?B?SVI1YkR2bzQzNm55ZDEvdno1V1FBaDdybU9kdFdHWVNFQ0hwMEtSd1JE?=
 =?iso-2022-jp?B?cEVkdTI3dEVMamM0bEVXeUp4NWpveUNCc2FRSUdGNUJ1bGRtb2N3NjdG?=
 =?iso-2022-jp?B?QzJLMzFKeG93YnBRdFZzbklCVmdjbkdZTGdnZUNnTGE4NTE4RE5PdDdD?=
 =?iso-2022-jp?B?SkNDUUQwR1FLQUxYRW81UEc0WDBIc0dYaTBseEJsTEQ0RDJTZXZEeE1C?=
 =?iso-2022-jp?B?V25QVnZINDRDYnhlSTFPTW16QVJKYU9ZYXBmQVovb1pJYTN0bHhXZ216?=
 =?iso-2022-jp?B?ejZOclkxakR0bTZyQUdHVkRhcnZTK2dlMFRGbENqaElOYUFEM24wN0tD?=
 =?iso-2022-jp?B?L0ZDUXllSFI5ZExZOHdMK0xpQnJpNFFKR28xQ3FHUVZjZEdDOGcrM0o2?=
 =?iso-2022-jp?B?dmNzaXZob1ByV1MwLzFqT3k5NjBiTEVaKzBCMDVGaDRmWVplUWhNSHVB?=
 =?iso-2022-jp?B?VjRYWTVvRFVxYVFtVFFnbkljR3hSQ0NIbFBPeG1BZlpGb09JVTFEeSta?=
 =?iso-2022-jp?B?cVIvYVgzMTNnOU1YQ04zbURDRDRHSDBEZHcrRDVTQTI2a0J2Yk9qZVBC?=
 =?iso-2022-jp?B?SlVHd0E4VHd5aElWTmFEczVYMDhoNE43OHhFY1ZYSEcvY0ZiVy9vV0V4?=
 =?iso-2022-jp?B?c1MySU9zSHJHRXlJWnRUSk5DY0tMMm9Id3A1WXMxcC9sekN2YmczR3Nq?=
 =?iso-2022-jp?B?Vms0bEgwcktBR1JQYitBckJKc2t6N3l2Q082NHNScjI2c1FoWFNpdTd4?=
 =?iso-2022-jp?B?c09tQWY5cjhJVzVEZTZjRjBnR3lDRFN1Q0dTcFp5SU9XMTFOUElHQnpL?=
 =?iso-2022-jp?B?L2V4UDFNYmZQbEdabWpyMU9ZditOZ1Zmb3JZYWh4R2xkZHhQbDI2TmtL?=
 =?iso-2022-jp?B?QXlpM1lnNXdQc2NKUTRyK3JObjhzR3dxK0FUVnN2aGhtei8zSkdxa0lj?=
 =?iso-2022-jp?B?a3FIV0RjdVVmelQ5UWhOWENQQnRtY3dQUlI3ZlhGRXd0TXA1YVJSa0pE?=
 =?iso-2022-jp?B?akZnK3piU25UYXNWTGRkNjFZdGRyRzZKV3BpRFo4ZDFGeHJPVnI4V0Fn?=
 =?iso-2022-jp?B?VTFJNHN6bVNnZGVudlZoVW14QVFKOEFFZXRFS1pHRlFORnRwUEhLT3B0?=
 =?iso-2022-jp?B?NVBpWmlNSXhzYmhrV1VGNlpWaExSd084YlgrZnFCY2U5L2s0Z1ZEN3BU?=
 =?iso-2022-jp?B?dGN4dXRtMU9zdmxFS1NuWFI1Vk5aMXRIQm9vZEhsQlpvb003bjJiNzA3?=
 =?iso-2022-jp?B?WFVRb3ZpQUNWVVR6bWtUM3FnZ0l2KzcyRWZVVmJBdFJFTC9CTWZQU1ow?=
 =?iso-2022-jp?B?d3JxVFhNVGQ1WUZPaEg1SkJCNHVxeW9nbE82aDF6MURRWTdsdmJJbU94?=
 =?iso-2022-jp?B?eEdVMEY3YjJLUFF2SXg0bFVOaHdlUmtNQWF4dz09?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB8798.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7acfe88a-6bf7-433c-6749-08de4ea1c4fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2026 10:36:23.4200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L7j5UKctWE2v/HgbiQ5ujypwSbYjWwihXop4hUoFe4bYrciMQHYXJ2cufhTTz18oCXdTXqx2LqpFByIEhU5mFNXRk6YJyXPLRhn7jORMDtk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY4PR01MB15081

Hello Ben,=0A=
=0A=
> From: James Morse <james.morse@arm.com>=0A=
> =0A=
> resctrl has its own data structures to describe its resources. We can't u=
se=0A=
> these directly as we play tricks with the 'MBA' resource, picking the MPA=
M=0A=
> controls or monitors that best apply. We may export the same component as=
=0A=
> both L3 and MBA.=0A=
> =0A=
> Add mpam_resctrl_exports[] as the array of class->resctrl mappings we are=
=0A=
> exporting, and add the cpuhp hooks that allocated and free the resctrl=0A=
> domain structures.=0A=
> =0A=
> While we're here, plumb in a few other obvious things.=0A=
> =0A=
> CONFIG_ARM_CPU_RESCTRL is used to allow this code to be built even though=
=0A=
> it can't yet be linked against resctrl.=0A=
> =0A=
> Signed-off-by: James Morse <james.morse@arm.com>=0A=
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>=0A=
> ---=0A=
> Domain list is an rcu list=0A=
> Add synchronize_rcu() to free the deleted element=0A=
> Code flow simplification (Jonathan)=0A=
> ---=0A=
>  drivers/resctrl/Makefile        |   1 +=0A=
>  drivers/resctrl/mpam_devices.c  |  12 ++=0A=
>  drivers/resctrl/mpam_internal.h |  22 +++=0A=
>  drivers/resctrl/mpam_resctrl.c  | 329 ++++++++++++++++++++++++++++++++=
=0A=
>  include/linux/arm_mpam.h        |   3 +=0A=
>  5 files changed, 367 insertions(+)=0A=
>  create mode 100644 drivers/resctrl/mpam_resctrl.c=0A=
> =0A=
> diff --git a/drivers/resctrl/Makefile b/drivers/resctrl/Makefile=0A=
> index 898199dcf80d..40beaf999582 100644=0A=
> --- a/drivers/resctrl/Makefile=0A=
> +++ b/drivers/resctrl/Makefile=0A=
> @@ -1,4 +1,5 @@=0A=
>  obj-$(CONFIG_ARM64_MPAM_DRIVER)                 +=3D mpam.o=0A=
>  mpam-y                                          +=3D mpam_devices.o=0A=
> +mpam-$(CONFIG_ARM_CPU_RESCTRL)                 +=3D mpam_resctrl.o=0A=
>  =0A=
>  ccflags-$(CONFIG_ARM64_MPAM_DRIVER_DEBUG)       +=3D -DDEBUG=0A=
> diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_device=
s.c=0A=
> index 860181266b15..303aacfcb9d6 100644=0A=
> --- a/drivers/resctrl/mpam_devices.c=0A=
> +++ b/drivers/resctrl/mpam_devices.c=0A=
> @@ -1628,6 +1628,9 @@ static int mpam_cpu_online(unsigned int cpu)=0A=
>                          mpam_reprogram_msc(msc);=0A=
>          }=0A=
>  =0A=
> +       if (mpam_is_enabled())=0A=
> +               mpam_resctrl_online_cpu(cpu);=0A=
=0A=
return mpam_resctrl_online_cpu(cpu);=0A=
=0A=
> +=0A=
>          return 0;=0A=
>  }=0A=
>  =0A=
> @@ -1671,6 +1674,9 @@ static int mpam_cpu_offline(unsigned int cpu)=0A=
>  {=0A=
>          struct mpam_msc *msc;=0A=
>  =0A=
> +       if (mpam_is_enabled())=0A=
> +               mpam_resctrl_offline_cpu(cpu);=0A=
> +=0A=
>          guard(srcu)(&mpam_srcu);=0A=
>          list_for_each_entry_srcu(msc, &mpam_all_msc, all_msc_list,=0A=
>                                   srcu_read_lock_held(&mpam_srcu)) {=0A=
> @@ -2517,6 +2523,12 @@ static void mpam_enable_once(void)=0A=
>          mutex_unlock(&mpam_list_lock);=0A=
>          cpus_read_unlock();=0A=
>  =0A=
> +       if (!err) {=0A=
> +               err =3D mpam_resctrl_setup();=0A=
> +               if (err)=0A=
> +                       pr_err("Failed to initialise resctrl: %d\n", err)=
;=0A=
> +       }=0A=
> +=0A=
>          if (err) {=0A=
>                  mpam_disable_reason =3D "Failed to enable.";=0A=
>                  schedule_work(&mpam_broken_work);=0A=
> diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_inter=
nal.h=0A=
> index e6e7ba4342d6..554e4887ba81 100644=0A=
> --- a/drivers/resctrl/mpam_internal.h=0A=
> +++ b/drivers/resctrl/mpam_internal.h=0A=
> @@ -12,6 +12,7 @@=0A=
>  #include <linux/jump_label.h>=0A=
>  #include <linux/llist.h>=0A=
>  #include <linux/mutex.h>=0A=
> +#include <linux/resctrl.h>=0A=
>  #include <linux/spinlock.h>=0A=
>  #include <linux/srcu.h>=0A=
>  #include <linux/types.h>=0A=
> @@ -333,6 +334,17 @@ struct mpam_msc_ris {=0A=
>          struct mpam_garbage     garbage;=0A=
>  };=0A=
>  =0A=
> +struct mpam_resctrl_dom {=0A=
> +       struct mpam_component   *ctrl_comp;=0A=
> +       struct rdt_ctrl_domain  resctrl_ctrl_dom;=0A=
> +       struct rdt_mon_domain   resctrl_mon_dom;=0A=
> +};=0A=
> +=0A=
> +struct mpam_resctrl_res {=0A=
> +       struct mpam_class       *class;=0A=
> +       struct rdt_resource     resctrl_res;=0A=
> +};=0A=
> +=0A=
>  static inline int mpam_alloc_csu_mon(struct mpam_class *class)=0A=
>  {=0A=
>          struct mpam_props *cprops =3D &class->props;=0A=
> @@ -387,6 +399,16 @@ void mpam_msmon_reset_mbwu(struct mpam_component *co=
mp, struct mon_cfg *ctx);=0A=
>  int mpam_get_cpumask_from_cache_id(unsigned long cache_id, u32 cache_lev=
el,=0A=
>                                     cpumask_t *affinity);=0A=
>  =0A=
> +#ifdef CONFIG_RESCTRL_FS=0A=
> +int mpam_resctrl_setup(void);=0A=
> +int mpam_resctrl_online_cpu(unsigned int cpu);=0A=
> +void mpam_resctrl_offline_cpu(unsigned int cpu);=0A=
> +#else=0A=
> +static inline int mpam_resctrl_setup(void) { return 0; }=0A=
> +static inline int mpam_resctrl_online_cpu(unsigned int cpu) { return 0; =
}=0A=
> +static inline void mpam_resctrl_offline_cpu(unsigned int cpu) { }=0A=
> +#endif /* CONFIG_RESCTRL_FS */=0A=
> +=0A=
>  /*=0A=
>   * MPAM MSCs have the following register layout. See:=0A=
>   * Arm Memory System Resource Partitioning and Monitoring (MPAM) System=
=0A=
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctr=
l.c=0A=
> new file mode 100644=0A=
> index 000000000000..4beeeded00ff=0A=
> --- /dev/null=0A=
> +++ b/drivers/resctrl/mpam_resctrl.c=0A=
> @@ -0,0 +1,329 @@=0A=
> +// SPDX-License-Identifier: GPL-2.0=0A=
> +// Copyright (C) 2025 Arm Ltd.=0A=
> +=0A=
> +#define pr_fmt(fmt) "%s:%s: " fmt, KBUILD_MODNAME, __func__=0A=
> +=0A=
> +#include <linux/arm_mpam.h>=0A=
> +#include <linux/cacheinfo.h>=0A=
> +#include <linux/cpu.h>=0A=
> +#include <linux/cpumask.h>=0A=
> +#include <linux/errno.h>=0A=
> +#include <linux/list.h>=0A=
> +#include <linux/printk.h>=0A=
> +#include <linux/rculist.h>=0A=
> +#include <linux/resctrl.h>=0A=
> +#include <linux/slab.h>=0A=
> +#include <linux/types.h>=0A=
> +=0A=
> +#include <asm/mpam.h>=0A=
> +=0A=
> +#include "mpam_internal.h"=0A=
> +=0A=
> +/*=0A=
> + * The classes we've picked to map to resctrl resources, wrapped=0A=
> + * in with their resctrl structure.=0A=
> + * Class pointer may be NULL.=0A=
> + */=0A=
> +static struct mpam_resctrl_res mpam_resctrl_controls[RDT_NUM_RESOURCES];=
=0A=
> +=0A=
> +/* The lock for modifying resctrl's domain lists from cpuhp callbacks. *=
/=0A=
> +static DEFINE_MUTEX(domain_list_lock);=0A=
> +=0A=
> +static bool exposed_alloc_capable;=0A=
> +static bool exposed_mon_capable;=0A=
> +=0A=
> +bool resctrl_arch_alloc_capable(void)=0A=
> +{=0A=
> +       return exposed_alloc_capable;=0A=
> +}=0A=
> +=0A=
> +bool resctrl_arch_mon_capable(void)=0A=
> +{=0A=
> +       return exposed_mon_capable;=0A=
> +}=0A=
> +=0A=
> +/*=0A=
> + * MSC may raise an error interrupt if it sees an out or range partid/pm=
g,=0A=
> + * and go on to truncate the value. Regardless of what the hardware supp=
orts,=0A=
> + * only the system wide safe value is safe to use.=0A=
> + */=0A=
> +u32 resctrl_arch_get_num_closid(struct rdt_resource *ignored)=0A=
> +{=0A=
> +       return mpam_partid_max + 1;=0A=
> +}=0A=
> +=0A=
> +struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)=
=0A=
> +{=0A=
> +       if (l >=3D RDT_NUM_RESOURCES)=0A=
> +               return NULL;=0A=
> +=0A=
> +       return &mpam_resctrl_controls[l].resctrl_res;=0A=
> +}=0A=
> +=0A=
> +static int mpam_resctrl_control_init(struct mpam_resctrl_res *res,=0A=
> +                                    enum resctrl_res_level type)=0A=
> +{=0A=
> +       /* TODO: initialise the resctrl resources */=0A=
> +=0A=
> +       return 0;=0A=
> +}=0A=
> +=0A=
> +static int mpam_resctrl_pick_domain_id(int cpu, struct mpam_component *c=
omp)=0A=
> +{=0A=
> +       struct mpam_class *class =3D comp->class;=0A=
> +=0A=
> +       if (class->type =3D=3D MPAM_CLASS_CACHE)=0A=
> +               return comp->comp_id;=0A=
> +=0A=
> +       /* TODO: repaint domain ids to match the L3 domain ids */=0A=
> +       /*=0A=
> +        * Otherwise, expose the ID used by the firmware table code.=0A=
> +        */=0A=
> +       return comp->comp_id;=0A=
> +}=0A=
> +=0A=
> +static void mpam_resctrl_domain_hdr_init(int cpu, struct mpam_component =
*comp,=0A=
> +                                        struct rdt_domain_hdr *hdr)=0A=
> +{=0A=
> +       lockdep_assert_cpus_held();=0A=
> +=0A=
> +       INIT_LIST_HEAD(&hdr->list);=0A=
> +       hdr->id =3D mpam_resctrl_pick_domain_id(cpu, comp);=0A=
> +       cpumask_set_cpu(cpu, &hdr->cpu_mask);=0A=
> +}=0A=
> +=0A=
> +/**=0A=
> + * mpam_resctrl_offline_domain_hdr() - Update the domain header to remov=
e a CPU.=0A=
> + * @cpu:       The CPU to remove from the domain.=0A=
> + * @hdr:       The domain's header.=0A=
> + *=0A=
> + * Removes @cpu from the header mask. If this was the last CPU in the do=
main,=0A=
> + * the domain header is removed from its parent list and true is returne=
d,=0A=
> + * indicating the parent structure can be freed.=0A=
> + * If there are other CPUs in the domain, returns false.=0A=
> + */=0A=
> +static bool mpam_resctrl_offline_domain_hdr(unsigned int cpu,=0A=
> +                                           struct rdt_domain_hdr *hdr)=
=0A=
> +{=0A=
> +       lockdep_assert_held(&domain_list_lock);=0A=
> +=0A=
> +       cpumask_clear_cpu(cpu, &hdr->cpu_mask);=0A=
> +       if (cpumask_empty(&hdr->cpu_mask)) {=0A=
> +               list_del_rcu(&hdr->list);=0A=
> +               synchronize_rcu();=0A=
> +               return true;=0A=
> +       }=0A=
> +=0A=
> +       return false;=0A=
> +}=0A=
> +=0A=
> +static struct mpam_resctrl_dom *=0A=
> +mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res=
)=0A=
> +{=0A=
> +       int err;=0A=
> +       struct mpam_resctrl_dom *dom;=0A=
> +       struct rdt_mon_domain *mon_d;=0A=
> +       struct rdt_ctrl_domain *ctrl_d;=0A=
> +       struct mpam_class *class =3D res->class;=0A=
> +       struct mpam_component *comp_iter, *ctrl_comp;=0A=
> +       struct rdt_resource *r =3D &res->resctrl_res;=0A=
> +=0A=
> +       lockdep_assert_held(&domain_list_lock);=0A=
> +=0A=
> +       ctrl_comp =3D NULL;=0A=
> +       guard(srcu)(&mpam_srcu);=0A=
> +       list_for_each_entry_srcu(comp_iter, &class->components, class_lis=
t,=0A=
> +                                srcu_read_lock_held(&mpam_srcu)) {=0A=
> +               if (cpumask_test_cpu(cpu, &comp_iter->affinity)) {=0A=
> +                       ctrl_comp =3D comp_iter;=0A=
> +                       break;=0A=
> +               }=0A=
> +       }=0A=
> +=0A=
> +       /* class has no component for this CPU */=0A=
> +       if (WARN_ON_ONCE(!ctrl_comp))=0A=
> +               return ERR_PTR(-EINVAL);=0A=
> +=0A=
> +       dom =3D kzalloc_node(sizeof(*dom), GFP_KERNEL, cpu_to_node(cpu));=
=0A=
> +       if (!dom)=0A=
> +               return ERR_PTR(-ENOMEM);=0A=
> +=0A=
> +       if (exposed_alloc_capable) {=0A=
> +               dom->ctrl_comp =3D ctrl_comp;=0A=
> +=0A=
> +               ctrl_d =3D &dom->resctrl_ctrl_dom;=0A=
> +               mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, &ctrl_d->hdr=
);=0A=
> +               ctrl_d->hdr.type =3D RESCTRL_CTRL_DOMAIN;=0A=
> +               /* TODO: this list should be sorted */=0A=
> +               list_add_tail_rcu(&ctrl_d->hdr.list, &r->ctrl_domains);=
=0A=
> +               err =3D resctrl_online_ctrl_domain(r, ctrl_d);=0A=
> +               if (err) {=0A=
> +                       dom =3D ERR_PTR(err);=0A=
> +                       goto offline_ctrl_domain;=0A=
> +               }=0A=
> +       } else {=0A=
> +               pr_debug("Skipped control domain online - no controls\n")=
;=0A=
> +       }=0A=
> +=0A=
> +       if (exposed_mon_capable) {=0A=
> +               mon_d =3D &dom->resctrl_mon_dom;=0A=
> +               mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, &mon_d->hdr)=
;=0A=
> +               mon_d->hdr.type =3D RESCTRL_MON_DOMAIN;=0A=
> +               /* TODO: this list should be sorted */=0A=
> +               list_add_tail_rcu(&mon_d->hdr.list, &r->mon_domains);=0A=
> +               err =3D resctrl_online_mon_domain(r, mon_d);=0A=
> +               if (err) {=0A=
> +                       dom =3D ERR_PTR(err);=0A=
> +                       goto offline_mon_hdr;=0A=
> +               }=0A=
> +       } else {=0A=
> +               pr_debug("Skipped monitor domain online - no monitors\n")=
;=0A=
> +       }=0A=
> +=0A=
> +       return dom;=0A=
> +=0A=
> +offline_mon_hdr:=0A=
> +       mpam_resctrl_offline_domain_hdr(cpu, &mon_d->hdr);=0A=
> +offline_ctrl_domain:=0A=
> +       resctrl_offline_ctrl_domain(r, ctrl_d);=0A=
> +=0A=
> +       return dom;=0A=
> +}=0A=
> +=0A=
> +static struct mpam_resctrl_dom *=0A=
> +mpam_resctrl_get_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)=
=0A=
> +{=0A=
> +       struct mpam_resctrl_dom *dom;=0A=
> +       struct rdt_ctrl_domain *ctrl_d;=0A=
> +       struct rdt_resource *r =3D &res->resctrl_res;=0A=
> +=0A=
> +       lockdep_assert_cpus_held();=0A=
> +=0A=
> +       list_for_each_entry_rcu(ctrl_d, &r->ctrl_domains, hdr.list) {=0A=
> +               dom =3D container_of(ctrl_d, struct mpam_resctrl_dom,=0A=
> +                                  resctrl_ctrl_dom);=0A=
> +=0A=
> +               if (cpumask_test_cpu(cpu, &dom->ctrl_comp->affinity))=0A=
> +                       return dom;=0A=
> +       }=0A=
> +=0A=
> +       return NULL;=0A=
> +}=0A=
> +=0A=
> +int mpam_resctrl_online_cpu(unsigned int cpu)=0A=
> +{=0A=
> +       guard(mutex)(&domain_list_lock);=0A=
> +       for (int i =3D 0; i < RDT_NUM_RESOURCES; i++) {=0A=
> +               struct mpam_resctrl_dom *dom;=0A=
> +               struct mpam_resctrl_res *res;=0A=
> +=0A=
> +               res =3D &mpam_resctrl_controls[i];=0A=
> +               if (!res->class)=0A=
> +                       continue;       // dummy_resource;=0A=
> +=0A=
> +               dom =3D mpam_resctrl_get_domain_from_cpu(cpu, res);=0A=
> +               if (!dom)=0A=
> +                       dom =3D mpam_resctrl_alloc_domain(cpu, res);=0A=
> +               if (IS_ERR(dom))=0A=
> +                       return PTR_ERR(dom);=0A=
> +       }=0A=
> +=0A=
> +       resctrl_online_cpu(cpu);=0A=
> +=0A=
> +       return 0;=0A=
> +}=0A=
> +=0A=
> +void mpam_resctrl_offline_cpu(unsigned int cpu)=0A=
> +{=0A=
> +       resctrl_offline_cpu(cpu);=0A=
> +=0A=
> +       guard(mutex)(&domain_list_lock);=0A=
> +       for (int i =3D 0; i < RDT_NUM_RESOURCES; i++) {=0A=
> +               struct mpam_resctrl_res *res;=0A=
> +               struct mpam_resctrl_dom *dom;=0A=
> +               struct rdt_mon_domain *mon_d;=0A=
> +               struct rdt_ctrl_domain *ctrl_d;=0A=
> +               bool ctrl_dom_empty, mon_dom_empty;=0A=
> +=0A=
> +               res =3D &mpam_resctrl_controls[i];=0A=
> +               if (!res->class)=0A=
> +                       continue;       // dummy resource=0A=
> +=0A=
> +               dom =3D mpam_resctrl_get_domain_from_cpu(cpu, res);=0A=
> +               if (WARN_ON_ONCE(!dom))=0A=
> +                       continue;=0A=
> +=0A=
> +               ctrl_dom_empty =3D true;=0A=
> +               if (exposed_alloc_capable) {=0A=
> +                       ctrl_d =3D &dom->resctrl_ctrl_dom;=0A=
> +                       ctrl_dom_empty =3D mpam_resctrl_offline_domain_hd=
r(cpu, &ctrl_d->hdr);=0A=
> +                       if (ctrl_dom_empty)=0A=
> +                               resctrl_offline_ctrl_domain(&res->resctrl=
_res, ctrl_d);=0A=
> +               }=0A=
> +=0A=
> +               mon_dom_empty =3D true;=0A=
> +               if (exposed_mon_capable) {=0A=
> +                       mon_d =3D &dom->resctrl_mon_dom;=0A=
> +                       mon_dom_empty =3D mpam_resctrl_offline_domain_hdr=
(cpu, &mon_d->hdr);=0A=
> +                       if (mon_dom_empty)=0A=
> +                               resctrl_offline_mon_domain(&res->resctrl_=
res, mon_d);=0A=
> +               }=0A=
> +=0A=
> +               if (ctrl_dom_empty && mon_dom_empty)=0A=
> +                       kfree(dom);=0A=
> +       }=0A=
> +}=0A=
> +=0A=
> +int mpam_resctrl_setup(void)=0A=
> +{=0A=
> +       int err =3D 0;=0A=
> +       struct mpam_resctrl_res *res;=0A=
> +=0A=
> +       cpus_read_lock();=0A=
> +       for (enum resctrl_res_level i =3D 0; i < RDT_NUM_RESOURCES; i++) =
{=0A=
> +               res =3D &mpam_resctrl_controls[i];=0A=
> +               INIT_LIST_HEAD_RCU(&res->resctrl_res.ctrl_domains);=0A=
> +               INIT_LIST_HEAD_RCU(&res->resctrl_res.mon_domains);=0A=
> +               res->resctrl_res.rid =3D i;=0A=
> +       }=0A=
> +=0A=
> +       /* TODO: pick MPAM classes to map to resctrl resources */=0A=
> +=0A=
> +       /* Initialise the resctrl structures from the classes */=0A=
> +       for (enum resctrl_res_level i =3D 0; i < RDT_NUM_RESOURCES; i++) =
{=0A=
> +               res =3D &mpam_resctrl_controls[i];=0A=
> +               if (!res->class)=0A=
> +                       continue;       // dummy resource=0A=
> +=0A=
> +               err =3D mpam_resctrl_control_init(res, i);=0A=
> +               if (err) {=0A=
> +                       pr_debug("Failed to initialise rid %u\n", i);=0A=
> +                       break;=0A=
> +               }=0A=
> +       }=0A=
> +       cpus_read_unlock();=0A=
> +=0A=
> +       if (err) {=0A=
> +               pr_debug("Internal error %d - resctrl not supported\n", e=
rr);=0A=
> +               return err;=0A=
> +       }=0A=
> +=0A=
=0A=
Considering the fixes added in [PATCH v2 27/45],=0A=
How about changing the code as follows? =0A=
=0A=
+		err =3D mpam_resctrl_control_init(res, i);=0A=
+		if (err) {=0A=
+			pr_debug("Failed to initialise rid %u\n", i);=0A=
+			pr_debug("Internal error %d - resctrl not supported\n", err);=0A=
+			cpus_read_unlock();=0A=
+			return err;=0A=
+		}=0A=
+	}=0A=
+           /* Find some classes to use for monitors */=0A=
+         mpam_resctrl_pick_counters();=0A=
+         for (enum resctrl_event_id j =3D 0; j < QOS_NUM_EVENTS; j++) {=0A=
+         =1B$B!D=1B(B=0A=
+ }=0A=
+	cpus_read_unlock();=0A=
=0A=
=0A=
Best regards,=0A=
Shaopeng TAN=0A=
=0A=
> +       if (!exposed_alloc_capable && !exposed_mon_capable) {=0A=
> +               pr_debug("No alloc(%u) or monitor(%u) found - resctrl not=
 supported\n",=0A=
> +                        exposed_alloc_capable, exposed_mon_capable);=0A=
> +               return -EOPNOTSUPP;=0A=
> +       }=0A=
> +=0A=
> +       if (!is_power_of_2(mpam_pmg_max + 1)) {=0A=
> +               /*=0A=
> +                * If not all the partid*pmg values are valid indexes,=0A=
> +                * resctrl may allocate pmg that don't exist. This=0A=
> +                * should cause an error interrupt.=0A=
> +                */=0A=
> +               pr_warn("Number of PMG is not a power of 2! resctrl may m=
isbehave");=0A=
> +       }=0A=
> +=0A=
> +       /* TODO: call resctrl_init() */=0A=
> +=0A=
> +       return err;=0A=
> +}=0A=
> diff --git a/include/linux/arm_mpam.h b/include/linux/arm_mpam.h=0A=
> index 7f00c5285a32..2c7d1413a401 100644=0A=
> --- a/include/linux/arm_mpam.h=0A=
> +++ b/include/linux/arm_mpam.h=0A=
> @@ -49,6 +49,9 @@ static inline int mpam_ris_create(struct mpam_msc *msc,=
 u8 ris_idx,=0A=
>  }=0A=
>  #endif=0A=
>  =0A=
> +bool resctrl_arch_alloc_capable(void);=0A=
> +bool resctrl_arch_mon_capable(void);=0A=
> +=0A=
>  /**=0A=
>   * mpam_register_requestor() - Register a requestor with the MPAM driver=
=0A=
>   * @partid_max:                The maximum PARTID value the requestor ca=
n generate.=0A=
> --=0A=
> 2.43.0=0A=
