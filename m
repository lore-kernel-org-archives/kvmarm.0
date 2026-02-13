Received: from TY3P286CU002.outbound.protection.outlook.com (mail-japaneastazon11010050.outbound.protection.outlook.com [52.101.229.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E721B18A6A7
	for <kvmarm@lists.linux.dev>; Fri, 13 Feb 2026 07:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.229.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770967128; cv=fail; b=m7W4DWpOKxrfiJGfURMp7TBpoHCSV7w4jwkTy0c3AL13VbQCW5cFVigOiwZ4d4notIwwTcoCEUE+iNAGcakPVuLAT4pbqAVq/Z1Sd5FV2726Ya9N/xLRm03zKm5ArHTd1wHcVUE90X4xyJcwS593f9TUYq5fsz+A8QDF7pvduIQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770967128; c=relaxed/simple;
	bh=3gsgo4UXNLtXMIyBibM2L21tTvys/oKvCBDcw7PfZmQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AqcTI/WQ6pafZut9S8y2+O5QnFL3Aupi3t2gZHvdtelWgtJfqgohDiyZQhzUPsJ4g/odVtqPXYXzbMMBgMv886BLUOLd+ydDLE1TE9i5aTMKBOhre7r8TBkAYl0EFNyA7lmShJA1XF2cYW5/DE9JDgs6ZZRM/xZOIRi/PCBia6M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=hkrUpDv5; arc=fail smtp.client-ip=52.101.229.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="hkrUpDv5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SAQdI76CdWAICS2nawOush4zV4l3T4ymlX0CkD9IMqYRpcIwh+Vue1Ij1M17iLQ5x6gq4oJ8YwdwjEi3TjkyXaL8D4z1/sMlFp82BcyLbIWKhu8bOIgfvpXSxDxwiLJjby2j12G+Xr7i9+wiUfl//j/AvVoxO35cDUAcEGndj3XEzNQeDXt2FMNFIjVU9zjOcM9aSkqvb8CVx3pvzP0BWqztMyF6x7eg0cAOrAd5JkoP/iqkI/LRmQ+BHpKsqx0S0L3va/j3uI4/frSG7UpfyuZnuUuiFm4NtyvzJpc8a0jrNicxqQbjdk8rs+1BvJ03e12yKkOEt7zmHdQquxAVpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3gsgo4UXNLtXMIyBibM2L21tTvys/oKvCBDcw7PfZmQ=;
 b=L/F2O7ps73bUozMR+VfhCNe0oF4bx4stvbprTum4/GqNx6tePA+Q+l11abJwVzKWeScweTrkPozD1uNdyJcCZse6hdh1XPPIQHfNLupsZnEyWll51unKv9c0skFY9xuBKXm83rZ+H/g4sPrDAbuYKFvTwbVwqrzKdP3r9ajRuK5Qy/7QOpaIfnWhOlv1ejpRY1WqzfcQ8iD7gvpBDFEgevTgwEqbWScBd+M0TU18IiEb8RcWEQh7KhmXpesvZdhVHGh7Dl7YhgcvG7cwrmYmSs/zl91YmqPE4f9pToCTdih7i8nwV2Og0ZbwXLn+Drc+BPprDvN18MarhtsRH4EsPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3gsgo4UXNLtXMIyBibM2L21tTvys/oKvCBDcw7PfZmQ=;
 b=hkrUpDv5IUMQT2PgKqP8C9b0UjAFhE73Oth07Gc27fCN/nuv4CZARVZgY7HrOr25rTlFcWwk4uCSC3yuRDBb5yUbhqEMEwXDAWdW0mRvLzO24glicDwtpbctY9toDBqZhEixbcon/+zrYlBda1Ouavimna0jaYtjpKuZUvUe4lpyqn7jL1x/LHvyXG8QYlDKEw/0NpzvJg5WI1fg0yI95Yt4E8iTx1ZBclsawSTEtnyKkwwGAY3o03NFmAvWOQ+2L/ot37NGwt1UnsNs/KRbxI7cyRUmkaxbZHeXqVPqri5lOoFqHtc3ctm82nVvWAxAdfI9+BKvMjvZh/US9DYBEw==
Received: from OSZPR01MB8798.jpnprd01.prod.outlook.com (2603:1096:604:15f::6)
 by OSZPR01MB6814.jpnprd01.prod.outlook.com (2603:1096:604:131::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.13; Fri, 13 Feb
 2026 07:18:44 +0000
Received: from OSZPR01MB8798.jpnprd01.prod.outlook.com
 ([fe80::e366:d390:4474:8cfa]) by OSZPR01MB8798.jpnprd01.prod.outlook.com
 ([fe80::e366:d390:4474:8cfa%5]) with mapi id 15.20.9611.012; Fri, 13 Feb 2026
 07:18:44 +0000
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
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "zengheng4@huawei.com"
	<zengheng4@huawei.com>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 00/41] arm_mpam: Add KVM/arm64 and resctrl glue code
Thread-Topic: [PATCH v4 00/41] arm_mpam: Add KVM/arm64 and resctrl glue code
Thread-Index: AQHclVY3YCku0pTXX0WF2WHphkfTbrV6DFS5gAAf04CABQdjgIABERjO
Date: Fri, 13 Feb 2026 07:18:44 +0000
Message-ID:
 <OSZPR01MB8798B8FFB379B002AEAE78618B61A@OSZPR01MB8798.jpnprd01.prod.outlook.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
 <OSZPR01MB87983A126E58D3FE8A73A98F8B65A@OSZPR01MB8798.jpnprd01.prod.outlook.com>
 <9a8a163e-887a-45fc-aae5-45e564360c8b@arm.com>
 <962e8fc7-aec9-48bd-aa75-d33f3b068e2a@arm.com>
In-Reply-To: <962e8fc7-aec9-48bd-aa75-d33f3b068e2a@arm.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=True;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2026-02-13T07:18:43.964Z;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=1;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OSZPR01MB8798:EE_|OSZPR01MB6814:EE_
x-ms-office365-filtering-correlation-id: 9cab648c-7460-4028-ba69-08de6ad01f4f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021|1580799027;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZFZoQTNJVW1qTUp0UG5IUzgxVHNBTnVkekhTS1Iybmo3aVFUYzVOaG03b1NH?=
 =?utf-8?B?c1B4c002bHhqTDJIaFN2Y0tqOFJsQUJ3T1grYm94UmFJNThPWEthQTVVOXZv?=
 =?utf-8?B?NStEcE9MbTVyWnVzRjIxK0lDZE1OMFdVWEJWUmxvN1A1RDR4WXBMOWt4RFJC?=
 =?utf-8?B?cjZMQ3RoSzJMSjVnMUgwODIzNGtxdEs1SE9OdFNjK3ljSHFqRndWWjJXaHFx?=
 =?utf-8?B?WDg4UnJmZlk1WVlocXRlQ0Q5SllNKzBOZHpGR1NBTFlQNHpwc0dnekFPTUd1?=
 =?utf-8?B?MFVhYzBNU1F0clNxL2pGak12SzZjRVZPVlhkZEZsblp4V0FzZ21hcXNEYlND?=
 =?utf-8?B?eVhWSTNoT1czb1B0ckM2Q1JHVFg0Ym9XYkNBVVFlYzRiTnQxZ21GeWk2dEd1?=
 =?utf-8?B?VllpUVpTTkU3UEo5WGxZbWVOdnQ3SkU4cFFickc2Sy9ZMnlORm1CakplOEpz?=
 =?utf-8?B?aXpVVm0wSVBZdmhOQ0kzSGF4UENpTStKNTZOeHRrWmVNNk1sai94NWs0MTdF?=
 =?utf-8?B?dmRuSE1jK0xRRUJiQUFkL28ra2xVREl4ZGtKR1A5Yi8xc3IyMUhUamcxeU5H?=
 =?utf-8?B?VlcwTkxPTWpRQzlkMk14aER6N1NLWnU0ZytsZXRjaWFvSGUwcDF5V25yVkZP?=
 =?utf-8?B?eURsTkVSOFZtakxraklnWkZDRjdIYmJFRjFxZ3I5MFhYcFcrdGtVbTJuUHE4?=
 =?utf-8?B?OUt0UXkvRzRXVXJPTjhXcXFoUi95dE9JeXVnK09NZUdaTXdTVHRPU0tLNFRC?=
 =?utf-8?B?d1ZLcW5XSnV6cU9nYytaOXBjaEp4cXYvWFFiQUxqTmJFa0lJQjJEbFdvMXFy?=
 =?utf-8?B?aGMrd09raW5UN1Z1ZlFjMU5xTkVwMXNkdEE2VWc4YzFsVjhRaDZlbzhjeUZW?=
 =?utf-8?B?TjZTbC8ycU1KQTRNbGlENkNaNGFDWEFaWXhyS1VrMk0xQkZKWHg0cm5rZTZq?=
 =?utf-8?B?QlgwUk5wbU1ZOWZQdXRVSW9wZERXM1FIbkZaRkNnZHNxN3NQTXM4ZzJJalhp?=
 =?utf-8?B?Y1lTeUlna0ZlVWFQSmxXWlRCdUF6alB3em9DeDFON0ExcDNPME9sSUVadlJq?=
 =?utf-8?B?MkdSMXNrNEVnekJWd2VoQVlpc09sRlJOaGJuTFVQdFY2dURsZCtBSmdrbnBR?=
 =?utf-8?B?UVEvYmFpV1lUOFRGWVhySUt1eGlRVmt6M2JGc2dTSnFieTAvaDBTZitSZjhG?=
 =?utf-8?B?bmZmNHRMRjJFemc2RWJiYU1wU1JKSjBXUGJTNGEwWTk3WDkrSzBFR0tjV3J5?=
 =?utf-8?B?TXFoWWQxRml4TjlnT1F3TG9OejJuY1FvRjhCNnE2VFR6dEFZdER1VnVRaTI5?=
 =?utf-8?B?aXhxbHZRUmtuR1NxT05wQmEwTDVZYzBDUzF3eFdyZHNIa1RoaE4zSWRNU1Zv?=
 =?utf-8?B?TGRYcjMwWElKZ3Z5N1pQZnF3R3pwR2llSGdYSG9WM3dUZGEwaW5RdzczM1pn?=
 =?utf-8?B?TmorVEZaZk1vVUdrdC9MTE04cVNLYWdKdCtTYko1UUxXM3ZjcEdwVmhTNXZG?=
 =?utf-8?B?Z1F6RHlub2s4WHlNTkRuVTdtTkpOREJkNjhvaXIxNWxkR2J1c1hhYjU5V2VI?=
 =?utf-8?B?UmM0S25OSE9Lcmx3ZXZXKzRGSUo0UjJBUWl1MXNyMU1kbmtuSk9uRVUzeE1v?=
 =?utf-8?B?RUE3a1BXc2M5eUZSaE1pRXd5SjhsanczV2VTa1dxbCtBWXpFNG0yZENkeDhl?=
 =?utf-8?B?UGlOb254anJWdHBSTWdpbUtXTE01VERIMEdscXJjTzJtU3N6YkZGUEw4M05K?=
 =?utf-8?B?S1hvN1RTSW5Oc1hVZTB5TnkyazhmZ0ljS0lzd0RGdTlxQ2ZXTFNEdVNwTVU1?=
 =?utf-8?B?M0VIYlNEaVRCR3hSOGxtRklPaVlGUlgweGZQZXZBbElRcktkTGw3Qk1DWVFY?=
 =?utf-8?B?QjM2aExueVRRTDd6N25VSDZEcmorRXBxRTZqM2pGdy9KNnF2Mmh2eUozS2Zq?=
 =?utf-8?B?UWZBdFFVSWUvT0djbndRWlJNcDRraXFDSE03TmdlYno4b05hWUZRdVo5NDdW?=
 =?utf-8?B?aFBiMVNxTC9GV3pzdW04cldIVzZjaWhrUnNwMlFKYVpvT1pNR0ZuM3lDRzUr?=
 =?utf-8?B?VUU4M3FUR1Z4TElPcXBmbWhUTkFJSjUrYXRMS2ZnSVpySHBaNnRNVjJHdmRn?=
 =?utf-8?B?UGtmelFKMFZkR093Q0x1dWUzMkZ2M3FwYkxPUzFaZnpDa3JndFc1ZHN4b1JM?=
 =?utf-8?Q?g7+hLMPzUdz7fQ0UVtLN5aPFjFGDB4hkQ4GObpihNCqp?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB8798.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021)(1580799027);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Vk5HK211aTVCZHFCNmFJd0JCWFh6QTg3MTdHeDJ4OEh0QS92L1JWeFdOcEhy?=
 =?utf-8?B?cFc2Zzgwb0Mvb1NjcDFTV3NiR1dFSWt6d1h4RWhDVUFEUmwxQ1ZrQjdlaDQy?=
 =?utf-8?B?SzA2UHcwWUZzcmhud0tBV05wNFdBV1gvMWgxWlVCKzQzTWZPRUphN2I2M3A4?=
 =?utf-8?B?ZmtRdldPQW8wZEYvWElBZTBGUW5BWWd1Rk9vNURrT3BLTDdOTDdpUmJ5MlBM?=
 =?utf-8?B?RnRXcm1lano3NFdPeDVjb2ZLVGc3Y2dXUTFPUU9YQXJsOU1jbFF5L0pLekpL?=
 =?utf-8?B?RzNHNktjN1dXZzdVdVZMbHd4b09DclphOThLWThPclcvQWVvYzRwYzdrWFM0?=
 =?utf-8?B?WW9LY1R1ZXhKRVM3dWtVa1FwVnVodWp2RGJXck5yZHBYVXI1ZjhtKzdQOFAv?=
 =?utf-8?B?c21SR0daQ1RrdkFBSDVFaGZQRkpycFI1OUUyTSt5bEtrV0ZnNkJxOXA2ODEv?=
 =?utf-8?B?cXQyZ0pZbEVaRnFDNlQxc0pCcmxTT1Z0SVRhbU5XQmJKa0EvbEdtOGhHRHVL?=
 =?utf-8?B?SHlZQUljUkNWaDJzOGJkOU15c3B3YnlnOVo5K01YNW1sRlkwMXlVZm9kNkxZ?=
 =?utf-8?B?clJLSWRwMmgyQm9OQmtkRHpJOGhwWGtFNkJkNzR0OFQ4RktSZTJKZXFwZXgw?=
 =?utf-8?B?MmMxMGR4b1RjdVFQY1VVWVhxUXMyNDEzMWVDU2tjY0tKY3VLNThpcVVlK25E?=
 =?utf-8?B?MFZaVTlPaXk1Q3B2NFdBMmtMS1g3NHgvS0w4dXV2eHpZMjBhUGwxdUxpdW9o?=
 =?utf-8?B?cUZzOHBNMDlSbVp3U3pKZ05yVkF2aitKak5YUmlmN0liRDVqdDNnenVoaFNW?=
 =?utf-8?B?dzJwMi82S0tLYTN3MUNjbnRYdjVOckdvV2lsS2FEOXBQanNRcXFFZ1o4bWFK?=
 =?utf-8?B?bnZKanp3RGlZbUFyU0haeFBtVkVFUEVvV2pjY3hyVjdrMVVIcERoNUtPSmNX?=
 =?utf-8?B?YmdwSDVac3hJQ2daVkF3NWNMWXAxRVE4b002ZjlCd3A3Z3pibTZPU1RzdzRQ?=
 =?utf-8?B?TVJQVHF6aU5wU0ZhRS8vRDd2WC9ZelJmdTBkaklrS25vUUtpQ25oN1JHNDNG?=
 =?utf-8?B?VTdmNUd2MXdrZThWQTlkaHZLUTB0QjNKMmpSbkFqeXZ0emNPc0pXbTdqMXpS?=
 =?utf-8?B?NExNSzFDWjQ3ZWJPZW5xZlZRRDkranZjNWJ1S1BGUUNBcFEvUlpqTWJNUEJW?=
 =?utf-8?B?NEVMNk9JL2ZGU2ttMFBEdHNVMUFMOU1xWm45Q2lsQjJvekUrMVdPZ2ZCVEpX?=
 =?utf-8?B?Z2ZzTHlKcVVHTmFHWjlFQnFQT0lFcHpsMnU0MjF4UUtmemxOSCtCS1ZhRmVl?=
 =?utf-8?B?N2ZUdittakdLR0xGSmZtcTVLVUZSQlFmcWVkaThUU0V4NGJlL0V6UnJQcEwy?=
 =?utf-8?B?L2w4QlZDczlia2NnRGFIVzlSbjl4V25CczU3bHR2aTczbk1zRzBzYWhnT3Q1?=
 =?utf-8?B?TmNOL2tpNkdCQXV2cVIwb21TVHJHUjgvbmFYNnkrb2lMQ2YxM21LZHpGK2xi?=
 =?utf-8?B?RkdHa2dlYk5ySjFiVlBZTHRvYjZPaEdTL09BREhzanRRSy9mLzZWMVg3cTNY?=
 =?utf-8?B?Q1NBWTZjUmVHcmE2R3ZOZ0p4dEduSlpYL2p2NjJ4VE1GZXBPMXU3WThLL3dr?=
 =?utf-8?B?YUk5WkxaNUJlMU9FV0RPRDJ0bWNEQUVsMnNnTVhGK2lZSXhMc3NsdnVLNXh4?=
 =?utf-8?B?MldLT0thOTdBNGNNMnVHeks4UEszZWtHaDhpc2VqR2JkdnFjUTVZa00xZDV3?=
 =?utf-8?B?WnZsNmk1MTg1RGg3QnZVYTB0bU42WnltejlNZXVndnVIQjlDZCs3MUV1ZE5P?=
 =?utf-8?B?ZXlCdDJoZ0phNkxIWjlwazNacWRZcGxnTm5vZnNsSjAyLzg5ZkVBT2kzTHBV?=
 =?utf-8?B?Um5BTDB1VlQ5VzZlRHRET293RUVocjRTRitCY1J6eDgwL0dXdm1mcDB1Nk1S?=
 =?utf-8?B?QUMyWlNlcmJheUxzVUN5YmJXaTJEWjZzQ241Z25rRW5sbzVMY3lOTkFOM2x5?=
 =?utf-8?B?NzkwRVB3Q1pDcnJ3dkxxdVVWMU5jOGZXMXVmanlVSGs2RklVdVZTSGw0UTFu?=
 =?utf-8?B?NlBlejhQWVF6QlErV1llakNDZVptQUVmZU1aaW81cHNOdGxoZEprZThKQmc3?=
 =?utf-8?B?bmVhS2RvMlFmc01kL2ZKNHY1dzBHU1BwQlBzWjYwRkg0cUwyUzZZWS9oRVdD?=
 =?utf-8?B?N0FCSGJVSDhJMXhFNXdJQmwveStYbGtNTXg0d2lpVVk2bXBsZHphaURVZWVx?=
 =?utf-8?B?OGVzWFBDUHZkZTIvek1CUldWZjcrcjYydHBmRHlTc2tJM1VOQnE1emhtVVhL?=
 =?utf-8?B?VmIxRDVyMXhHTkhvSXQycHR5VE5qZk0yOXVhK29NcnBtTllxZ2VEUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB8798.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cab648c-7460-4028-ba69-08de6ad01f4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2026 07:18:44.3964
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bi9YTeJefL1iSVBdfsu7bcFh83zvU2ZQekj1og63/pk1pCkXp7PmCqP/KaQBL2U+W0QfH3oGepCjq9rbQJXJFhN/nRgi+HKn01ppm5ziVsc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB6814

SGVsbG8gQmVuLAoKCj4gSGkgU2hhb3BlbmcsCj4gCj4gT24gMi85LzI2IDEwOjA0LCBCZW4gSG9y
Z2FuIHdyb3RlOgo+ID4gSGkgU2hhb3BlbmcsCj4gPiAKPiA+IE9uIDIvOS8yNiAwODoyNSwgU2hh
b3BlbmcgVGFuIChGdWppdHN1KSB3cm90ZToKPiA+PiBIZWxsbyBCZW4sCj4gPj4KPiA+Pj4gVGhp
cyBuZXcgdmVyc2lvbiBvZiB0aGUgbXBhbSBtaXNzaW5nIHBpZWNlcyBzZXJpZXMgaGFzIGEgZmV3
IHNpZ25pZmljYW50Cj4gPj4+IGNoYW5nZXMgaW4gdGhlIG1wYW0gZHJpdmVyIHBhcnQgb2YgdGhl
IHNlcmllcy4gVGhlIGhldXJpc3RpY3MgZm9yIGRlY2lkaW5nCj4gPj4+IGlmIGZlYXR1cmVzIHNo
b3VsZCBiZSBleHBvc2VkIGFyZSB0aWdodGVuZWQuIFRoaXMgaXMgdG8gZml4IHNvbWUKPiA+Pj4g
aW5hY2N1cmFjaWVzIGFuZCBhdm9pZCBvdmVyY29tbWl0dGluZyBiZWZvcmUgbmVlZGVkIC0gc2hv
dXQgaWYgdGhpcyBjaGFuZ2VzCj4gPj4+IGFueXRoaW5nIG9uIHlvdXIgcGxhdGZvcm0uIFRoZSBm
aW5hbCBwYXRjaCBhZGRzIGRvY3VtZW50YXRpb24gd2hpY2gKPiA+Pj4gZXhwbGFpbnMgd2hpY2gg
ZmVhdHVyZXMgeW91IHNob3VsZCBleHBlY3QuIFRoZSBBQk1DIGVtdWxhdGlvbiBpcyBkcm9wcGVk
Cj4gPj4+IGZvciB0aGUgbW9tZW50IGFzIGl0IHJlcXVpcmVzIHJlc2N0cmwgY2hhbmdlcyB0byBz
dXBwb3J0IGZvciBNUEFNIHdpdGhvdXQKPiA+Pj4gYnJlYWtpbmcgdGhlIGFiaS4gVGhlIGRlZmF1
bHQgNSUgZ2FwIGZvciBtaW5fYncgaXMgZHJvcHBlZCBpbiBmYXZvdXIgb2YgYQo+ID4+PiBzaW1w
bGUgZGVmYXVsdCAoa2VwdCBmb3IgZ3JhY2UpLiBUaGUgc2VyaWVzIGlzIGJhc2VkIG9uIHg4Ni9y
ZXNjdHJsIFsxXSBhcwo+ID4+PiByZXNjdHJsIGhhcyB0ZWxlbWV0cnkgcGF0Y2hlcyBxdWV1ZWQg
d2hpY2ggY2hhbmdlIHRoZSBhcmNoIGludGVyZmFjZS4KPiA+Pgo+ID4+IENvdWxkIHlvdSBwbGVh
c2UgZWxhYm9yYXRlIG9uIHdoeSBmcy9yZXNjdHJsIGNoYW5nZXMgYXJlIHJlcXVpcmVkIHRvIHN1
cHBvcnQgb25seSB0aGUgY291bnRlciBhc3NpZ25tZW50IHBhcnQgb2YgQUJNQz8KPiA+PiBDdXJy
ZW50bHksIG1hbnkgU29DIGNoaXBzIGhhdmUgYW4gaW5zdWZmaWNpZW50IG51bWJlciBvZiBtZW1v
cnkgYmFuZHdpZHRoIG1vbml0b3JzLgo+ID4gCj4gPiBTdXJlLiBXaGVuIHRoZSBjb3VudGVyIGFz
c2lnbm1lbnQgbW9kZSBpcyAnbWJtX2V2ZW50OyByZXNjdHJsIGFzc3VtZXMgdGhlIG1ibSBldmVu
dHMgYXJlIGNvbmZpZ3VyYWJsZS4gCj4gPiBUaGUgJ2V2ZW50X2ZpbHRlcicgZmlsZXMgYXQKPiA+
wqDCoMKgwqAgaW5mby9MM19NT04vZXZlbnRfY29uZmlncy88ZXZlbnQ+L2V2ZW50X2ZpbHRlciAK
PiA+IGFyZSB1c2VkIHRvIGRpc3BsYXkgYW5kIHNldCB0aGlzIGNvbmZpZ3VyYXRpb24uCj4gPiAK
PiA+IEluIE1QQU0gZXZlbnQgY29uZmlndXJhdGlvbiBpcyBub3Qgc3VwcG9ydGVkIGFuZCBzbyBz
aG93aW5nIGEgcmVhZC93cml0YWJsZSAnZXZlbnRfZmlsdGVyJyBmaWxlIGlzIAo+ID4gbWlzbGVh
ZGluZyB0byB0aGUgdXNlciBhbmQgbmVlZHMgdG8gYmUgaGlkZGVuIGZvciBNUEFNIHN1cHBvcnQu
Cj4gPiAKPiA+IEp1c3QgdG8gZ2l2ZSB5b3UgYSBmbGF2b3VyIG9mIHRoZSBjaGFuZ2UsIGhlcmUn
cyBhIGhhY2sgdG8gc2hvdyB0aGUgY29ycmVjdCB0aGluZyBmb3IgTVBBTToKPiA+IAo+ID4gLS0t
IGEvZnMvcmVzY3RybC9yZHRncm91cC5jCj4gPiArKysgYi9mcy9yZXNjdHJsL3JkdGdyb3VwLmMK
PiA+IEBAIC0yMzM4LDYgKzIzMzgsOSBAQCBzdGF0aWMgaW50IHJlc2N0cmxfbWtkaXJfZXZlbnRf
Y29uZmlncyhzdHJ1Y3QgcmR0X3Jlc291cmNlICpyLCBzdHJ1Y3Qga2VybmZzX25vZAo+ID7CoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAocmV0KQo+ID7CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBvdXQ7Cj4gPsKgIAo+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKCFyZXNjdHJsX2FyY2hfaXNfZXZ0X2NvbmZp
Z3VyYWJsZShtZXZ0LT5ldnRpZCkpCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgY29udGludWU7Cj4gPiArCj4gPiAKPiA+IAo+ID4+IFdlIHdvdWxkIGJl
IGdyYXRlZnVsIGlmIHlvdSBjb3VsZCBzdXBwb3J0IHRoZSBjb3VudGVyIGFzc2lnbm1lbnQgcGFy
dCBvZiBBQk1DLgo+ID4gCj4gPiBJdCBpcyBub3QgYSBiaWcgY2hhbmdlIGluIHJlc2N0cmwgYnV0
IEkgdGhvdWdodCBpdCBiZXN0IHRvIG5vdCBnYXRlIHRoZSByZXN0IG9mIHRoaXMgc2VyaWVzIG9u
Cj4gPiBhbiBhZGRpdGlvbmFsIGNoYW5nZSBpbiBhbm90aGVyIHN1YnN5c3RlbS4gSSBhbSBjdXJy
ZW50IGxvb2tpbmcgaW50byB0aGlzIGFuZCBob3BlIHRvIGdldCB0aGUgCj4gPiBwYXRjaGVzIG9u
IHRoZSBsaXN0IGVhcmx5IGluIHRoZSBuZXh0IGN5Y2xlLgo+IAo+IFRoZXJlIGlzIGFub3RoZXIg
c21hbGwgY2hhbmdlIHRoYXQgd2lsbCBiZSByZXF1aXJlZCBpbiByZXNjdHJsIHRvCj4gc3VwcG9y
dCBBQk1DIHdpdGggTVBBTS4gQXMgY291bnRlciBhc3NpZ25tZW50IG1lYW5zIHRoYXQgaXQgY2Fu
J3QgYmUKPiBndWFyYW50ZWVkIHRoYXQgZWFjaCBDVFJMX01PTiBncm91cCBoYXMgYSBkZWRpY2F0
ZWQgbWVtb3J5IGJhbmR3aWR0aAo+IGNvdW50ZXIgdGhlIHNvZnR3YXJlIGNvbnRyb2xsZXIgKG1i
YU1CcHMgbW91bnQgb3B0aW9uKSB3b24ndCB3b3JrIGJ1dAo+IHRoZSBtb3VudCB3b24ndCBmYWls
LiBBTUQgZG9lc24ndCBoaXQgdGhpcyBwcm9ibGVtIGFzIGl0J3MgTUJBIGlzCj4gbm9uLWxpbmVh
ci4gSSB3YXMgaG9waW5nIHRvIHJlcHVycG9zZSB0aGUgZGVsYXlfbGluZWFyIGZsYWcgdG8ganVz
dCBtZWFuCj4gdGhlIHNvZnR3YXJlIGNvbnRyb2xsZXIgaXNuJ3Qgc3VwcG9ydGVkIGJ1dCByZXNj
dHJsIGRpc3BsYXlzIHRoaXMKPiBpbmZvcm1hdGlvbiB0byB0aGUgdXNlciBpbiB0aGUgJ2RlbGF5
X2xpbmVhcicgZmlsZSBhbmQgd2UgZG9uJ3Qgd2FudCB0bwo+IG1pc2xlYWQuCj4gCgpUaGFuayB5
b3UgZm9yIHlvdXIgZGV0YWlsZWQgZXhwbGFuYXRpb24uCgpJIHJldGVzdGVkIHRoaXMgcGF0Y2gg
c2VyaWVzIGFuZCB0aGVyZSBpcyBubyBwcm9ibGVtLgpJIHJldmlld2VkIHRoZSBzb3VyY2UgY29k
ZSwgYW5kIGl0IGxvb2tzIGZpbmUgdG8gbWUuCgpUZXN0ZWQtYnk6IFNoYW9wZW5nIFRhbiA8dGFu
LnNoYW9wZW5nQGpwLmZ1aml0c3UuY29tPgpSZXZpZXdlZC1ieTogU2hhb3BlbmcgVGFuIDx0YW4u
c2hhb3BlbmdAanAuZnVqaXRzdS5jb20+CgpCZXN0IHJlZ2FyZHMsClNoYW9wZW5nIFRBTgo=
