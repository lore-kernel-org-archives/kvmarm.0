Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DED311C2C
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 01:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786325390; cv=fail; b=eyxJK2Y6W8hCGah4uzKqH9HS6c8O6yFACa2MnnZU/2GdDtyn4793GGFRBWRcz6cuFCwXhgXB0Ui1ehbaibJRb/bYMTe5Nkg2ygTn70dU3tvYwgsg2azeH3lec26TaTfZ7d1MGp4UR+bVNeUe9lK4oxQ2X+j65+njv1BzQch8BGU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786325390; c=relaxed/simple;
	bh=KJVyYDAu9oTtl6PukNXbPc3Me7jyqh4zg5WQ3glo2MA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HxR+XV/MXY2qA30hy6+PLrPhEpB+yCk16xCsCAWt7uZrryYsXEuThe/7c08CvtjPsMtfUiBRXMW0ZBDpFk6IiMXdPUx4deI6PGek/sKFuTf9LmqBX1FXuEHAEi3+hgtNSFqHvIEYjU4DaNjQlWahGj/z7DsoZ5bGs/qc/aOBDqg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=etmp6E94; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="etmp6E94"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786325387; x=1817861387;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KJVyYDAu9oTtl6PukNXbPc3Me7jyqh4zg5WQ3glo2MA=;
  b=etmp6E94+j/SES3dFFDnn9/LigYNBkZIElk0z8aB5AXaToamWLc/DvD/
   oDq4RskU1x1pSF1zLsA77te6/4Pyv1lyl/TdqnFm3KewKVdT1E+Kr1BUR
   EtFk/gn63Xq6vRRDJVtDgRQptD7nn37OOpVM5Su8YHAV+NvxEsDvc1SHh
   5bv2hnmZKDY4K5gue6vTy5Z+o7+JTYLhtfaHUukaIyRUlcATs6JZSE8F4
   fjTL3Ng2Hb8h4bnzyhyt4TNZnO9g8FGOnD/ldD9B7uOMFvhPhRLecteLf
   mXj6dOOvcWfpLMRkQ8PrMvQYLuqGhlcMfvwOy61TCJRYudV7mp24GcGwu
   Q==;
X-CSE-ConnectionGUID: 9btY3/c+RmW49+pLtOElHg==
X-CSE-MsgGUID: LiZxNSpiSAew3qlQBDIKpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11870"; a="104225942"
X-IronPort-AV: E=Sophos;i="6.25,214,1779174000"; 
   d="scan'208";a="104225942"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2026 18:29:47 -0700
X-CSE-ConnectionGUID: 4DKzM5WQQP+K0QXaKPHEDA==
X-CSE-MsgGUID: C8rqDwkTR8qHhnJ0x/tW6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,214,1779174000"; 
   d="scan'208";a="259582023"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2026 18:29:46 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 9 Aug 2026 18:29:46 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Sun, 9 Aug 2026 18:29:46 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.21) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 9 Aug 2026 18:29:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G7lT9Nw4LxUV96GPDNm1khN9i6jrq82cI1A88YJCZlJxejQXhEXBiPDoTjRYDmnO+QC9woWRWqhKIba9HSLenkfUHttiBJvXIYOd+1p9n/kWwKahKQGFVyLw1MAmILF4Q1VAhzOdKwhDzGnD8uQQtevcY9o5rsCqIOSfJEdJAegUqjggjgnm+rRn38RL4IgYQkYxIr8irSUJ084OQG1y3n6+TYjKve/m5J9gwdsVQbfQ/gEejq+akAbw4mrkNVChpUX39vofowmr2UdvT4x36+XLsuauh84xeLN31BP8MC8T7ehto4zj0LNB22ECL1/ndXTLXSB6sUexkrvlUc1EjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KJVyYDAu9oTtl6PukNXbPc3Me7jyqh4zg5WQ3glo2MA=;
 b=fIpSoceFtl46UgXK/Te6VwSJb48wdUDUGoaW3j7e7Pb5WwKk/GiK5IuyE8Fy5bAza6m+f0q6KVfTfN2AP3rLiiw9wNgeMCQBPVjTWk3z8etS4GCK2UjhFlHs69x0aZ4D1ioa53od1iRLYc43aoR0yAxqv5fDjdofUh9lIgB91lrkpj0z2N1UC3sjtCUfAov6fPbGBI/wH4OrPvd2bbIYucqdRkBsMxY8bW4bSP7wk10ZGqqqzkGb/disnGP2j7w7uGvPrnD3sf3D7ZG+pg8b9vrnrwX2N8otBGiOFEVHHNmPuFOfNnuvfp1eoa3gobNqStp52BfZroRGq5QdApcQmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH0PR11MB5300.namprd11.prod.outlook.com (2603:10b6:610:bf::18)
 by DM4PR11MB7326.namprd11.prod.outlook.com (2603:10b6:8:106::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 01:29:44 +0000
Received: from CH0PR11MB5300.namprd11.prod.outlook.com
 ([fe80::3a08:e2e0:c8b9:7a7c]) by CH0PR11MB5300.namprd11.prod.outlook.com
 ([fe80::3a08:e2e0:c8b9:7a7c%6]) with mapi id 15.21.0292.024; Mon, 10 Aug 2026
 01:29:43 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "maz@kernel.org" <maz@kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "oupton@kernel.org" <oupton@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"seiden@linux.ibm.com" <seiden@linux.ibm.com>
Subject: Re: [PATCH] KVM: Never clear KVM_REQ_VM_DEAD from a vCPU's requests
Thread-Topic: [PATCH] KVM: Never clear KVM_REQ_VM_DEAD from a vCPU's requests
Thread-Index: AQHdJe0anT6ZXxgFcU+KXMCw4ElF6raWg5IA
Date: Mon, 10 Aug 2026 01:29:43 +0000
Message-ID: <4122846f2c7a9b8025aa9915162ae605d5853ed4.camel@intel.com>
References: <20260806214618.82180-1-seanjc@google.com>
In-Reply-To: <20260806214618.82180-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.58.3 (3.58.3-1.fc43) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR11MB5300:EE_|DM4PR11MB7326:EE_
x-ms-office365-filtering-correlation-id: 73da5210-f642-484c-8fc3-08def67edb3e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|18002099003|22082099003|6133799003|5023799004|11063799006|56012099006|10067099003|38070700021;
x-microsoft-antispam-message-info: 0QChyQmYejj8gMxWjlbtWhsn7zqI203fpY0+/J0P4GZ6CsdTjwiKEd3Ez//DU6Qli/1M/TmIgCRpN5xA8TS58Pry56ftjv4C8HvI5W4oK/xkuxcvs6f7LwZQY415Lp5USYB1xDBT43X4+UJYLwM6N3YMmoEv18FxIGitZNTCa5OoMxMtVukv45Mlk2v4QulKrTfrHIvIwgBztit2cO/+IlxH8bJtJZ9MjkBOiQwRvbN44pvggPSgggtoiDt7pKap0QGniNgitCkQpVUbZCeVNhCnJeIuHRPDscgWIVDhbf47Tum22XBwgIVJG1wJeqikVWNMa1+lEh/BODtqxUFBJBzEnLJ+Gp7LdT1Ep5DLd4X8P6aKCNZ+vKTsQnnHPiM69Git8P0lzyiSbuYJJI798Usq7q0cG3G8UGhAO6G3x4pn7ws7EDVMRbvBp7JkxWIGbQHJH6pvmxWMZiV5VxOz6UzXR8zpn6bd7On6jKtJHT/1Hk/gVCDpZ1rYa48B5OUkqu7yhGeBmikirgCZ8/VeEZM7nw62o/hldhIMo9oFFKC62f5yPDmotWOpMzWDjWDov5aeR+pM/GxaB/eWFrenUFGaC58uah9MT6x3UDPm01bw4GSDsXMoAVVrptU7vc5HUOo5s72N0hFkacS9Xx3XZppH/Ng59WIxZYARn4Jml9W1sE2SoaCZkBoYT3cbCot8KMSHRJZk+Iat0JErJ3dtc4EZig8WAM4Qh7yPM8FH0zk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5300.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(18002099003)(22082099003)(6133799003)(5023799004)(11063799006)(56012099006)(10067099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OU5yVU82V2tmNFkvNDJjRHAzTTUxRThGSkNwbHhrUkJGYTVUMkZuZ3VleXRt?=
 =?utf-8?B?WmVUYmJORzk5VUJCemc5Z0lNaEx0a1hidHlFVExEVm1PLzBHUmRmc0dOQ3lE?=
 =?utf-8?B?WUVLM2Y3OEI0UDB6b01Kb3IxN1BaSW9adDBSeFg4c3lCSFY4b1E2eXZYME1B?=
 =?utf-8?B?eUlNNFgwYWpGQVpobTJwdDRuNlhISjJIQUk0cFhQcEhLcmVwaTNaYTV3V0My?=
 =?utf-8?B?aUNTa1VGR1ZRTGNHc3JjV1JkUENrSGcyVHJVYlVqOUhFZzU4NGNoRTkzMDBN?=
 =?utf-8?B?YmdKSkxTRnJCdSsrVEE0dkN6UjZSdXgrR1FFR0dxVjdQWXRsTWIvR3JVT2da?=
 =?utf-8?B?RmFiYUwreWNiRUw0YjQza1Z5cFlaQ25zaUFRNmFBTnNxSTZGWFppd1N0Y3VJ?=
 =?utf-8?B?alR2cnZOSFhsOCsvQmtWOTR0NmFjQlhldlc3Y1hmMnBpbXpZWDdOSG9OVmdo?=
 =?utf-8?B?VlhYZlpZTDR6Z0srdWZyQTFBRHQxWXpVOHBqUk85UHo5TEFSWEFXZW1qZE9Y?=
 =?utf-8?B?OFYvT1FIK0x3Y1pvSjBqVHZDa0lJakJnR0VPejRSL2JkWTZHQTV3d1loVXhW?=
 =?utf-8?B?aC9BbnZEUFFQYW1YeGNJMkRkVlB0YzByWFZLVGtkMHkxMG03VWNjWFlCYXVr?=
 =?utf-8?B?Ni9ndi9mR08xT1dBMzMxTEVOaGtoaFovVFpWbU40dG9DOExrcThYVzh1b3Nx?=
 =?utf-8?B?WnFNNUVqUjRGQVZFanJ1cUVURDkzdTlyWkJDQTJDQzhFUzhBaGh0SnoyTm1u?=
 =?utf-8?B?Q1o1b0tRdEtmVVV1cXNHODlNR2dEb00xVHZ6bHFpZU5VVlgvT3hnanpWREtj?=
 =?utf-8?B?TmcxeHFCd3dLd01KU0kwd1g0dUFVZFY4bXVwek1CMjBtd3dtVHJGN2w5ZXo1?=
 =?utf-8?B?N3o0Q2M2M2VLd0JBVzZybEhGM1JyZzY4aXlPaDJuNUVtSmdzSXRQQkEvQUJi?=
 =?utf-8?B?endQTG9BbUgyTGplZ1dUV2NrMVdlK1RuZ2gxZWxRb0Yrai9jeUZwbzhiS1FV?=
 =?utf-8?B?WWNGTGRXMnY5cnExZW1GeExTUXNzMjgwRDBGSHA3dXJOTW1tN0o0dHpnSGhH?=
 =?utf-8?B?OEoxNGRQWVRIeEovN1JLV0piNEZTcDFtSFRBc0U2V1ZZeHI3U040VFRFdkJl?=
 =?utf-8?B?c0NyK29UWS9ndi9Da2tFb252LzZremZXY05XVE04ZGRlVllRbzc1WmwvZS9q?=
 =?utf-8?B?K3pxcTNtTVRwQWFwS2d3QnpYb0xoVWNhNFZqRElJU1dJTUZ0elVONUwxMXZm?=
 =?utf-8?B?bStBaTgwNmNoNmJMU2cvYVpmRjN5MDNkdHZRZnhqWTJVbzZZMDk4cEJxcGFm?=
 =?utf-8?B?VldxOS9FK0JDUG05dE8rZDVVdVZvaFppRWhvRWFMU1FteGJsNnJFWWhadG93?=
 =?utf-8?B?MUUxSHJxQk5USUdHeGlQR2NwVko1V3E0YTZvZlU5ZjNGRjhwdHFYekVRSVRF?=
 =?utf-8?B?OUJSYjZpQ24vWXoxQWNJdXg4ekUwTjFLZGdNWlJsUHBzUk5LcEc5ZklvREky?=
 =?utf-8?B?cWoybTdsRnFpeWdHMkN2QVdOSmxSRGsvUFF5bVBTRWVMM0RJczdIWk5td0NV?=
 =?utf-8?B?UVgrNitCVGJTaVlzRG1qdXBXeUhPNGhYN1hBQlYrQUtNaHJaSTV3TjdCNXpn?=
 =?utf-8?B?V1Y4N1k0STJ5T00xMlgwUnAxak9INnRxaVkvVjJsQnV0TXM2eUZORm1FNVE2?=
 =?utf-8?B?MEJPS2NnQjNqcTh5ZXExaUl2b25TNko1dCtDVGMzL05PamVXZ1NIdmQ5NUpp?=
 =?utf-8?B?dzBoK3VMeGtJd3Y2b1NZdnpCZTA3NWJhQ0ZlQzVHMFhaLzZWV1hYTVYwcllW?=
 =?utf-8?B?V0lEd3MwY0lsekErOXBDSFNSRHptVWI0Q2UySDAzVmoyTFE0SUVhWFFhdldG?=
 =?utf-8?B?UUJpOWFOdlA2WVBiU0pIaTNYcCt0VDVXWTdveGpzL2dsNHRSNWY4MEJzS1N0?=
 =?utf-8?B?cVJiZTRPWklRRTJrTWwrcHBqNXdUYXd5MU1Xd1hYZ3hwQnBFM1Q3Ni9nN2xQ?=
 =?utf-8?B?WXBmM1hTVzNLWHdISmYrdGdmd0NsWk9rdDJ2d21RSG5XeGJ1REJIYlVwTEJx?=
 =?utf-8?B?TGZPdkVpb2RXdW5Id092NjN2cUkwVHZSMm9GZ0ZwWS9ENUkyL0VRNmlzMERs?=
 =?utf-8?B?TzFRNDVOMWZON2V3bVUzbi9QZVJoSi9KZVlBY0ZjVS9ZZFFPMlNuTEpEbmlo?=
 =?utf-8?B?Z3M0anM0QlozKzN5ZjY4eFM4T1NYcG1YcG1qbWJzaU9zckZlckRVdTdQYlJP?=
 =?utf-8?B?MDhZbzRsZ1B2emhpa3E1VmhpU3g4VGJsYmJ4ZS9DVUlpNWlTdU1jS0pZSnBI?=
 =?utf-8?B?UGsvaDJiekNDZ1hmcHdmdmRIZzlLcGczYUZqUXU3R1FpUGhGVzN6Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E8BD54BF21E3BB42A0F2D7577A94834E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: s/dNz8Td0k3LFM8ef9p9mMTQz6GBbwZT67FE59JVEmIHJQxHbOid1DHg5h6W8h8cvdJsvk9gKX929Q9CF4eNYUHlYGn0rFzSTX3qZsLcpn8XI47qp1rSR6KpU3WFmAD3gCeWbAAZhJmTx1UoIqeWllOmS41ZY9wNLYSuPJzT0a0y19vSxwx1V+rhZ6J21DfW+TZtirf9mOuWIWpEsM+eCkcW5aEe7wq+pwYX2zzgkDzNmuOWaQUMGOgfJcdPBG8rFVv+3JTfTaAjWiXMEwAkkWC5dNq0jMAYZj1ZmMvpLUvNtewm3GqY4kPe2+ZNnzym3s7X0Rt7uVhsnL3reb08eg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5300.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73da5210-f642-484c-8fc3-08def67edb3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2026 01:29:43.7192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n78Pz1QE4+IXBowhZfQg3XW2uglsyAZ0gvo7fwI+7MEEpjI92JyE2FKY/tXAepOh73XLrpNrFxsbeHw00KlW2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7326
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI2LTA4LTA2IGF0IDE0OjQ2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBVc2Uga3ZtX3Rlc3RfcmVxdWVzdCgpIGluc3RlYWQgb2Yga3ZtX2NoZWNrX3JlcXVl
c3QoKSB3aGVuIHF1ZXJ5aW5nDQo+IEtWTV9SRVFfVk1fREVBRCwgaS5lLiBkb24ndCBjbGVhciBL
Vk1fUkVRX1ZNX0RFQUQsIGFzIHRoZSBlbnRpcmUgcHVycG9zZQ0KPiBvZiBLVk1fUkVRX1ZNX0RF
QUQgaXMgdG8gcHJldmVudCB0aGUgdkNQVSBmcm9tIGVudGVycmluZyB0aGUgZ3Vlc3QgZXZlcg0K
PiBhZ2FpbiwgZXZlbiBpZiB1c2Vyc3BhY2UgaW5zaXN0cyBvbiByZWRvaW5nIEtWTV9SVU4uDQo+
IA0KPiBFbnN1cmluZyBLVk1fUkVRX1ZNX0RFQUQgaXMgbmV2ZXIgY2xlYXJlZCB3aWxsIGFsbG93
IHJlbGF4aW5nIEtWTSdzIHJ1bGUNCj4gdGhhdCBpb2N0bHMgY2FuJ3QgYmUgaW52b2tlZCBvbiBk
ZWFkIFZNcywgdG8gb25seSBkaXNhbGxvdyBpb2N0bHMgaWYgdGhlDQo+IFZNIGlzIGJ1Z2dlZCwg
aS5lLiBpZiBLVk0gaGl0IGEgS1ZNX0JVR19PTigpLg0KPiANCj4gT3Bwb3J0dW5pc3RpY2FsbHkg
YWRkIGNvbXBpbGUtdGltZSBhc3NlcnRpb25zIHRvIGd1YXJkIGFnYWluc3QgY2xlYXJpbmcNCj4g
S1ZNX1JFUV9WTV9ERUFEIHRocm91Z2ggdGhlIHN0YW5kYXJkIEFQSXMuDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCg0KUmV2aWV3
ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg0KRldJVywgSSBidWlsZCB0
ZXN0ZWQgdGhhdCBib3RoIGdjYyBhbmQgY2xhbmcgY291bGQgYnVpbGQgc3VjY2Vzc2Z1bGx5IChi
b3RoIC1PMg0KYW5kIC1PcykuDQoNClsuLi5dDQoNCj4gLS0tIGEvaW5jbHVkZS9saW51eC9rdm1f
aG9zdC5oDQo+ICsrKyBiL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaA0KPiBAQCAtMjMyNCwxMyAr
MjMyNCwxOCBAQCBzdGF0aWMgaW5saW5lIGJvb2wga3ZtX3Rlc3RfcmVxdWVzdChpbnQgcmVxLCBz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ICAJcmV0dXJuIHRlc3RfYml0KHJlcSAmIEtWTV9SRVFV
RVNUX01BU0ssICh2b2lkICopJnZjcHUtPnJlcXVlc3RzKTsNCj4gIH0NCj4gIA0KPiAtc3RhdGlj
IGlubGluZSB2b2lkIGt2bV9jbGVhcl9yZXF1ZXN0KGludCByZXEsIHN0cnVjdCBrdm1fdmNwdSAq
dmNwdSkNCj4gK3N0YXRpYyBfX2Fsd2F5c19pbmxpbmUgdm9pZCBrdm1fY2xlYXJfcmVxdWVzdChp
bnQgcmVxLCBzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ICB7DQo+ICsJQlVJTERfQlVHX09OKHJl
cSA9PSBLVk1fUkVRX1ZNX0RFQUQpOw0KPiArDQo+ICAJY2xlYXJfYml0KHJlcSAmIEtWTV9SRVFV
RVNUX01BU0ssICh2b2lkICopJnZjcHUtPnJlcXVlc3RzKTsNCj4gIH0NCj4gIA0KPiAtc3RhdGlj
IGlubGluZSBib29sIGt2bV9jaGVja19yZXF1ZXN0KGludCByZXEsIHN0cnVjdCBrdm1fdmNwdSAq
dmNwdSkNCj4gK3N0YXRpYyBfX2Fsd2F5c19pbmxpbmUgYm9vbCBrdm1fY2hlY2tfcmVxdWVzdChp
bnQgcmVxLCBzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ICB7DQo+ICsJLyogT25jZSBhIFZNIGlz
IGRlYWQsIGl0IG5lZWRzIHRvIHN0YXkgZGVhZC4gKi8NCj4gKwlCVUlMRF9CVUdfT04ocmVxID09
IEtWTV9SRVFfVk1fREVBRCk7DQo+ICsNCj4gIAlpZiAoa3ZtX3Rlc3RfcmVxdWVzdChyZXEsIHZj
cHUpKSB7DQo+ICAJCWt2bV9jbGVhcl9yZXF1ZXN0KHJlcSwgdmNwdSk7DQo+ICANCg0KTml0OiBB
RkFJQ1QgdGhlIGNoYW5nZSB0byBfX2Fsd2F5c19pbmxpbmUgaXMgdG8gYXZvaWQgYnVpbGQgZmFp
bHVyZS4gIFBlcmhhcHMNCmV4cGxpY2l0bHkgbWVudGlvbiB0aGlzIGluIGNoYW5nZWxvZz8NCg0K
QnR3LCBJIGFsc28gdHJpZWQgYnVpbGRpbmcgdGhlIGtlcm5lbCBhZnRlciByZXZlcnRpbmcgX19h
bHdheXNfaW5saW5lIHRvIHBsYWluDQppbmxpbmUsIGJ1dCBpbmRlZWQgZ290IGJ1aWxkIGVycm9y
IHdoZW4gdXNpbmcgY2xhbmcgKGNsYW5nIGZhaWxlZCB3aXRoIGJvdGggLU8yDQphbmQgLU9zLCBi
dXQgZ2NjIHdhcyBmaW5lIGZvciBib3RoLCB0aG91Z2gpLg0K
