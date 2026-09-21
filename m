Received: from fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com [35.158.23.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8E443CE4B
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 07:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=35.158.23.94
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789976553; cv=fail; b=LFST1Rar9hOco+wuwLRRl43cHVLPrkUUFUZBcoMuock6KRTLaK6u72tIz61/wBDfrFmY/SFXez8sJY7p5P7RKZe1xH5TrAGXz8+mb4Nl28VfD4t/4UsVin1g91j++Z7QyEOlLuLIa21GcVdKFid92QktOGOxtgdS+m+Gnh0+c5s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789976553; c=relaxed/simple;
	bh=cteA6ymQcPv8XF5/iNGvOvGQ0b3qfMAmKE8RpIKVMRg=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=i3iRVRAPregExUrubI5UzUM5PtaIP2NzVNJ5sQUSbartW9G7VPLmtA1KgWR+4JjEDr1iR9f2v+jFw3CRcH0Xu7Vahrdc+atmIVQCLKbMouw5MUfV0j/hsfvu/PARNDZTBzBzYAH2HM2HwXtQGvrRLbG0/99LV34VbgqZnRMZmQE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=UM/BrW+J; arc=fail smtp.client-ip=35.158.23.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="UM/BrW+J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1789976551; x=1821512551;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=cteA6ymQcPv8XF5/iNGvOvGQ0b3qfMAmKE8RpIKVMRg=;
  b=UM/BrW+JDCx1SF+0mkEA6IrzH7qupGNelktv9NmAQp88Dvn2yWF3obyK
   WFaXfmZmSAs51vc8mZkwaJP/D+2yoShC+S67qWEVKcLYW1Az8lbkUDFny
   NuubHD5VnzER8oBOR0ydnR63GnjRgCnFY+Nia6/kVahScMHDh1GNKZPyn
   WcyqOfTte8POB/51rzxrNzqAid73Zf7sV7/FXz/RUfbvjl8AaJIer8aLn
   64fLuQo2xmQ03I3T/UvOpsH5SGV+iFzUYj89IaVsFVJ31liFtdjQwfjFt
   CPhrW4lj6T/Antz9YhbDHrEl4kmvqIIGIhPPIKH4DwQJTGTm0iWM40SVV
   Q==;
X-CSE-ConnectionGUID: 44AWsEK3RBqrQXBhGXgy+Q==
X-CSE-MsgGUID: eMMw6pn4SG60CGUgnVuI3w==
X-IronPort-AV: E=Sophos;i="6.27,114,1787011200"; 
   d="scan'208";a="19853765"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 07:42:26 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.226:15782]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.1.143:2525] with esmtp (Farcaster)
 id 8b607109-78e1-4020-afa8-6ee6653ba90a; Mon, 21 Sep 2026 07:42:26 +0000 (UTC)
X-Farcaster-Flow-ID: 8b607109-78e1-4020-afa8-6ee6653ba90a
Received: from EX19EXOEUB002.ant.amazon.com (10.252.51.83) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Mon, 21 Sep 2026 07:42:26 +0000
Received: from EX19EXOEUB001.ant.amazon.com (10.252.51.80) by
 EX19EXOEUB002.ant.amazon.com (10.252.51.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Mon, 21 Sep 2026 07:42:25 +0000
Received: from FR6P281CU001.outbound.protection.outlook.com (10.252.51.199) by
 EX19EXOEUB001.ant.amazon.com (10.252.51.80) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49
 via Frontend Transport; Mon, 21 Sep 2026 07:42:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ALbs5e+CrZjKtms28hEXJvnhYmXkpoLmRedehea1zCX9Pc47kmz5ERyM2xWulltYY8ITA4NSRqBGk+jVp72OMGogHhCdKfQfArdqCrGsx9pIoB36QTFsleQcN9/ZuxSGTEodXHIXFh24Iz8fO7B0CdMMUZ8tunE5KzuS3L863RLUmoICqmy4fkRIbrVsTyUACJlAAyTt5NgJTQ8OnTBNUAXG+qacrsYwTeB2vaFK6wJGmAuaAtU27o+PIgmm3F+XfIS2lGo2O5y0cHvRbkwtWnpUHJSX0FoDpLflFyLm8VOnYEVvBBHIZN5GWT7D51h5h4inDb+vPjiLQKS4Fk18Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cteA6ymQcPv8XF5/iNGvOvGQ0b3qfMAmKE8RpIKVMRg=;
 b=hBK9t+k7qk2ikCBKwq8an4ys1LHvxZXdJQudRrwk2wpeKWMhIepuu3gezmKV19INo4lCMNfHi9MXN+f+ktywQ3JtlYqPrLLd1Co6w72l5mLSx4BWwSoS1jRpXffrkNdYCcsPuXDEgxOGDloTO1cAMUb26l5KRhSxOjzS2ymloIK0vr/uxMVX6TK//T5fTvL6zbcarMLMrTYSNs/NpRDR2KbLB2fk+sZN6N/nJOEog/az5Vsu+iMETuWO7oyIUDx+NEu93PaCryOzL/X/1H8YZV0adFegl9EohzytnzC69Wv8kx8gl29JJThmDkESD10IxktgkQi9n6efCTydmNN7HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.de; dmarc=pass action=none header.from=amazon.de;
 dkim=pass header.d=amazon.de; arc=none
Received: from FR2P281MB3085.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:60::10)
 by BE1P281MB2918.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:4e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 07:42:14 +0000
Received: from FR2P281MB3085.DEUP281.PROD.OUTLOOK.COM
 ([fe80::c5ec:db93:1e10:765d]) by FR2P281MB3085.DEUP281.PROD.OUTLOOK.COM
 ([fe80::c5ec:db93:1e10:765d%4]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 07:42:13 +0000
From: "Graf (AWS), Alexander" <graf@amazon.de>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"legion@kernel.org" <legion@kernel.org>, "kees@kernel.org" <kees@kernel.org>,
	"will@kernel.org" <will@kernel.org>, "ruanjinjie@huawei.com"
	<ruanjinjie@huawei.com>, "atomlin@atomlin.com" <atomlin@atomlin.com>,
	"rppt@kernel.org" <rppt@kernel.org>, "jani.nikula@intel.com"
	<jani.nikula@intel.com>, "hamzamahfooz@linux.microsoft.com"
	<hamzamahfooz@linux.microsoft.com>, "joey.gouly@arm.com"
	<joey.gouly@arm.com>, "tglx@kernel.org" <tglx@kernel.org>, "nsc@kernel.org"
	<nsc@kernel.org>, "alexandre.chartre@oracle.com"
	<alexandre.chartre@oracle.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"dianders@chromium.org" <dianders@chromium.org>, "bp@alien8.de"
	<bp@alien8.de>, "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
	"shuah@kernel.org" <shuah@kernel.org>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "linux-kbuild@vger.kernel.org"
	<linux-kbuild@vger.kernel.org>, "linux-arch@vger.kernel.org"
	<linux-arch@vger.kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "jaredwhite@microsoft.com"
	<jaredwhite@microsoft.com>, "johan@kernel.org" <johan@kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"seanjc@google.com" <seanjc@google.com>, "mark.rutland@arm.com"
	<mark.rutland@arm.com>, "vdonnefort@google.com" <vdonnefort@google.com>,
	"tarunsahu@google.com" <tarunsahu@google.com>, "gshan@redhat.com"
	<gshan@redhat.com>, "skhan@linuxfoundation.org" <skhan@linuxfoundation.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "xur@google.com"
	<xur@google.com>, "djbw@kernel.org" <djbw@kernel.org>, "oupton@kernel.org"
	<oupton@kernel.org>, "nogikh@google.com" <nogikh@google.com>,
	"sumitg@nvidia.com" <sumitg@nvidia.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "zengheng4@huawei.com"
	<zengheng4@huawei.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"corbet@lwn.net" <corbet@lwn.net>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "luto@kernel.org" <luto@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "zhangpengjie2@huawei.com"
	<zhangpengjie2@huawei.com>, "x86@kernel.org" <x86@kernel.org>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "jic23@kernel.org"
	<jic23@kernel.org>, "ardb@kernel.org" <ardb@kernel.org>,
	"petr.pavlu@suse.com" <petr.pavlu@suse.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "kexec@lists.infradead.org"
	<kexec@lists.infradead.org>, "pratyush@kernel.org" <pratyush@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"rdunlap@infradead.org" <rdunlap@infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "fuad.tabba@linux.dev" <fuad.tabba@linux.dev>,
	"maz@kernel.org" <maz@kernel.org>, "mbenes@suse.cz" <mbenes@suse.cz>,
	"jgross@suse.com" <jgross@suse.com>, "seiden@linux.ibm.com"
	<seiden@linux.ibm.com>, "pierre.gondois@arm.com" <pierre.gondois@arm.com>,
	"song@kernel.org" <song@kernel.org>, "nathan@kernel.org" <nathan@kernel.org>,
	"pmladek@suse.com" <pmladek@suse.com>, "chao.gao@intel.com"
	<chao.gao@intel.com>, "zhenglifeng1@huawei.com" <zhenglifeng1@huawei.com>,
	"arnd@arndb.de" <arnd@arndb.de>, "sidnayyar@google.com"
	<sidnayyar@google.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "vladimir.murzin@arm.com"
	<vladimir.murzin@arm.com>, "kas@kernel.org" <kas@kernel.org>
Subject: Re: [RFC PATCH 00/46] Orphaned Virtual Machines
Thread-Topic: [RFC PATCH 00/46] Orphaned Virtual Machines
Thread-Index: AQHdSZy3a4jDEs+GTEqZwok8Lw53KA==
Date: Mon, 21 Sep 2026 07:42:13 +0000
Message-ID: <f0dca19e-a154-4597-99e8-7d03eb511d25@amazon.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amazon.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: FR2P281MB3085:EE_|BE1P281MB2918:EE_
x-ms-office365-filtering-correlation-id: 4f8ad6be-612d-4f41-8f7f-08df17b3d9ed
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|921020|6133799003|22082099003|18002099003|38070700021|56012099006|11063799006|10067099003|3023799007;
x-microsoft-antispam-message-info: 5zKGlSBEWZkSzt1EJ8bzGwQvpKdkgim2CW7LRshvPah1EFkIuWHEcH2UB+W0lo6J7tbx2NFebDnN/esv6hh1GiIvUTUqt10lTNU6nf+7a1gkUMgGaj+7duH3vhUobFBqrpDPbCBDhVw91mEQUiz892Kldn/YNH8+TR2M3TN1qE7pJVLnUTsHjiwfWbTijadT2tTD+DNPyrZwLDTEMNlRYivEQmdDqr/0KBW5BqMhEOG1srGmMPll0a/yz90+DAjZzc1Wz0YKDlbFyjNmYEomI1/xDMNef8q+/5hkux855E7Oja79eZDde1NF4TRi5trTwstehHIykMf0+hBQJsq7zmtGmgIia/rXYpw6F8tiRALhhmAacMLTnFB/cri23a+AkA36JSAmxZauiT1Jk2syS8rG1VwZo2QGLtLAOcNpoSroE+FakM/PmvyqJKtFIr0N6erhES2FBq4k/j7PEB8u0kEUm9Ws1iRjQdnAiBLJQNGTu+CqlN3535WMsN/OrIFyKgzhhaQbbQIsAqhtYo5lkT8RdE/XTyg7u+zjLg1tJXeK54iOaOJdc1kGiVVdezCU+YbflPWk9kuMVyfIXVJD9zAfU0nvjDEYLe0/+W9eGomNC15RYxPru7i/tU+4DGFXkw4KmI6EujVScSzT58A82SObU3bKTVCe6ncu8QFmDrXtCAFT7sktVOgO1zC+MV7b8ppAU2d+kgUO0Jg/hDjEEjNZizEzLTBIqM+RpO+ESOV3RAyqnHjz+kfHayJy57UF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR2P281MB3085.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(921020)(6133799003)(22082099003)(18002099003)(38070700021)(56012099006)(11063799006)(10067099003)(3023799007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWtaOERrTEYzbjRmL0JDSGhmL1MrU2JQeXBWVUFpQWRqSG1Pd2phS3hFNGFa?=
 =?utf-8?B?UUpBdUlvMlZJYUxkamN6bjhqM1gwYkdIK25Sd3IrYzZ5YWUzY3JNZ0JocDZF?=
 =?utf-8?B?ZE1LdHY5a1VkKzB3RmkrbEhsVkhkNUtuKzRoTG85ZmdnK0xGejdKdEdLcUkz?=
 =?utf-8?B?bm5HQnRvdWFIc2IvSmkxT1NjWGt3KzVmTi8zZ283eWV5cGl1anZCYkNaNVlT?=
 =?utf-8?B?cGJVME85cElscjRxQ2VzUDJYSjcrWkxhSndqNGFzaVFBSWZQNndPa2lIU3hw?=
 =?utf-8?B?dVdnOHo3dEdtMURyWVZRUEw5Qzh2NVdOamhDZTV3MTgzTEd3dE9sUEtkSkd4?=
 =?utf-8?B?WGNkNzFZRXFremErQjBXVEc4S0FETlkvL3BpQkhVcGdDeFJqUHVpOFBpd3Nx?=
 =?utf-8?B?ZTk1Y1Y4dXlKZ0hFZnowcXFDTGJ0SEdJU0dEZVB5TTgvK2kycGJVakh4SFls?=
 =?utf-8?B?Y05IeU50MTFZVGpCbEpUS2VUNXhFV0R6ODZSM0c5Y21KZUVYb0lqV3JwSndv?=
 =?utf-8?B?VURKOStuV0EvbkRKT1haOWhNNFVnRGVFMnFWQnJMb3B6ZUxweUYxczZmSWt4?=
 =?utf-8?B?ODNNRWZIVGlyWGFtblJxWGNvUEJpeEJHckRPUEdzcVBqd3ZKMTEwakY0Y0ZZ?=
 =?utf-8?B?UncrQkt3cEZlMElDb1JKSkpscW9PTkN0MzhWQ09pY01lRDcyT1B4Y0JIaU5a?=
 =?utf-8?B?dENGakt6dS9HREdZWFN6dE9VaitGWm1kUk16anlpQ1BkY0p5b3JMbzRtcFZM?=
 =?utf-8?B?V01sTWNtWWIzOEdpYjA2NVVFRlMza2I2QUl2dk5Nc1AxQTBKMy9LU1h6d2s4?=
 =?utf-8?B?N0h1NHczZWo1S2lCTTBmNThwSmM1eHZKY1YvdUdJc1VCcnRzUmNjbXNMdURR?=
 =?utf-8?B?SXYrVmVJcFg1Nk1QU1FKeVR1b3lCMTlGbmpxbm9HMTIxWmZtVjhTL1FSSW5y?=
 =?utf-8?B?dVdhOWwvek82Vi9kdzJCZ0dUSEJOd2tuL0lmTDFRMjZpNHN2a014MSszT1JW?=
 =?utf-8?B?TWxxUEpRR1N2aUNtaGNZNnlwUVNUNVdEaHFLNHYxS0d1TDFaNjZzaHdBK25m?=
 =?utf-8?B?a0RRMUUxZzJMb28xOFk4M29ObWwyQ3ZhallmamY3aFJjUFpHQ0NiMWswSmh6?=
 =?utf-8?B?V2YydVhkcVJMOVpEc2xyM3NBY0g3YW1LTjBZWHVqSGdaUDhpaVVSL1FJbWFx?=
 =?utf-8?B?bUZGVS9XUE5VZnRjOEdoeWlqY3hWaUVYRWw2c3BnY09MZGUvQnB3eDdoUkdw?=
 =?utf-8?B?SmRldXlZeFBWWmR6NnVQaVI4b1lTcjNWQWp5K0JXV1VHT2lrNWVpbFQ3OSt5?=
 =?utf-8?B?WjRycVVteXA5WHR5ZzhUY2poYThWcHlLR0F2S0xDeDFvdEdjWmV4dGN3ZGpt?=
 =?utf-8?B?VEhiT0ZXaVEweGt6QlUrMDVrUHlIYzRXbks1NC9qQ1dON3E3TG5BMmtORGNB?=
 =?utf-8?B?SFF3SVY4RGNuTWlQS2dZQ2dzQlYzZlFEVFhwcjJJdWdFT1ZuZ3hwZ3B4TUli?=
 =?utf-8?B?NllKeTNaWmpVNVJldENicDl3S2ZGMDkzcTRaSUlzNk9hQ1ZGMmVyNTZGNTFY?=
 =?utf-8?B?d0dTWTArNVdEcVBIYTR5VEFXWE54OUVGK1VTbWlQQitZdzlZcW12OW95Y1hZ?=
 =?utf-8?B?azRxdSt1d2JGWXNsTkhzdHNrZVBjSHk2cWc3NWZ1VmVGclJTeVBrZVZCaG9i?=
 =?utf-8?B?RnBxUDg5QmNKbU9ZMTJ2ZVFaUFdiMHJiMzFibTUxb2lZeXlWbnZJTWg1ZFNG?=
 =?utf-8?B?QWljMXVBcDRVOVVUUlVsOGtTSTYxeUdwNTBvcEZPeG80ZnlzRTEzSTJpaU1p?=
 =?utf-8?B?ZG9jWFBkdGhaQUpWQlhyVXlYTnhNQ2NIWU1nLzlmWnJ1cWVqdFR4Tkh4UlBw?=
 =?utf-8?B?MG5JSlg3Y09CVTF2bjM2Q1ZSZmN6M1BkZWNKYWdVbFZDN050R2RMZ3lDWHFE?=
 =?utf-8?B?ajg0Q3VTdmJ4Rmp3cmYvdnA0U21iN0NvUDhlN0Jna25tWTN3T2JLYVQySzNs?=
 =?utf-8?B?TXZGSzZnUDJ6eE5pM2ZlS1FGRi92WEtJNHZWRXB4Mnd5b2pVT2xiZjdmeFg5?=
 =?utf-8?B?cll3Z2RSSEtNVHdQVU9PTno1MVV2V1Z2WDRvR1RGbFprU1l0cXdxR3V0Sjg3?=
 =?utf-8?B?YW5jTFdoekRTTFJROHFZelczcUhjbm44OUljenM5WlRuQWxmMVBkNDZ4ZUZB?=
 =?utf-8?B?K01GSUVSbnJ4NmhCc0N4YXFkaEFtTXRzWFlMaldLMmRMN0crd0xoOGdrZzA5?=
 =?utf-8?B?eVVNTkdRRXdFRTZZQS81c0VDNWliWnUvUDFNRE1DcTB5WGd2SUtUdzZBRGVu?=
 =?utf-8?Q?XdGnC73qhCjEwxf+xw?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E90B47C3F684AA4EB8E5F617525D370A@DEUP281.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: 4uc4PbgN+N2bJjWYjQ1M08jtiS1yoqiJ6n6+9G9vmWxfkQvu6uu+jwWe+FqfHiBc8seSlfmdXgtGPoS7XrreCchkMhCOAaRiA/2knd6YampKlsK6d7sdXCRwIn4twm1IqRAQfL5QBNnouSJZmd2T9eM/l2/s+VNqnkrdxvlXenLYWcaDDr7eUeZs2K60uxDePhh8CjIGnmQMoJOR04X+32zyeks0EprIqzCPQ8JrU8d/syeCOunekWm0sZhqLM5FMBDywsO7CIubGgQTS6woKwOOsrqA4J3e/Fw/bypGawlWR9U3x567MbaXb5W/Dg8+1PeyXMYskzZT1h1Xf4gF4Q==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: FR2P281MB3085.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f8ad6be-612d-4f41-8f7f-08df17b3d9ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2026 07:42:13.2605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Izad5HGym2gCVsHT+oqFOXFDcuwF4lUh9U3a3DUBebyOhJcNhjfBFzPWXhHR9QQG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BE1P281MB2918
X-OriginatorOrg: amazon.de

DQpPbiAyMC4wOS4yNiAyMTozNiwgUGFzaGEgVGF0YXNoaW4gd3JvdGU6DQo+IFRoaXMgUkZDIHNl
cmllcyBpcyBhIFBvQyBpbnRlbmRlZCB0byBzaG93Y2FzZSBlMmUgd29ya2luZyBPcnBoYW5WTXMN
Cj4gdW5pbnRlcnJ1cHRlZCBjb250aW51aW5nIGV4ZWN1dGlvbiBvbiBwcmVzZXJ2ZWQgcGh5c2lj
YWwgQ1BVcyBhY3Jvc3MgYQ0KPiBob3N0IGtlcm5lbCBsaXZlIHVwZGF0ZSwgcHJlcGFyZWQgZm9y
IHRoZSBMUEMnMjYgcHJlc2VudGF0aW9uIGF0IHRoZQ0KPiBLVk0gTWljcm9jb25mIFsxXS4NCj4N
Cj4gVGhlIG9yaWdpbmFsIGRlc2lnbiBwcm9wb3NhbCBkaXNjdXNzaW9uIGNhbiBiZSBmb3VuZCBh
dCBbMl0uDQo+DQo+IFRoaXMgc2VyaWVzIGlzIGFwcGxpZWQgb24gdG9wIG9mIHY3LjMtcmMxICsg
dGhlICJbUEFUQ0ggdjQgMDAvMTFdDQo+IGxpdmV1cGRhdGU6IGt2bTogR3Vlc3RfbWVtZmQgcHJl
c2VydmF0aW9uIiBzZXJpZXMgWzNdLiBUaGUgd2hvbGUgYnJhbmNoDQo+IGNhbiBiZSBhY2Nlc3Nl
ZCBhdCBbNF0uDQo+DQo+IEl0IHdhcyB0ZXN0ZWQgb24gSW50ZWwgWGVvbiBHcmFuaXRlIFJhcGlk
cy1BUCwgQU1EIEVQWUMgVHVyaW4sIGFuZCBBUk0NCj4gTmVvdmVyc2UgVjIsIGFzIHdlbGwgYXMg
aW4gZW11bGF0aW9uIG9uIFFFTVUgYW5kIEludGVsIFNpbWljcy4gSG93ZXZlciwNCj4gaXQgaXMg
c3RpbGwgdmVyeSBlYXJseSBXSVAsIGFuZCBpcyBub3QgYW55d2hlcmUgbmVhciBiZWluZyBwcm9k
dWN0aW9uDQo+IHJlYWR5Lg0KPg0KPiBPdmVydmlldyAmIFN1Ym1pc3Npb24gU3RyYXRlZ3kNCj4g
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo+IFdoaWxlIHRoaXMgUkZDIGJ1bmRsZXMg
dGhlIGUyZSBzdGFjaywgaXQgaXMgTk9UIGludGVuZGVkIHRvIGJlIG1lcmdlZCBhcw0KPiBhIHNp
bmdsZSBzZXJpZXMsIHRoZSBnb2FsIG9mIHRoaXMgc2VyaWVzIGlzIHRvIGhhdmUgYSBkaXNjdXNz
aW9uIGFib3V0DQo+IHRoZSB0ZWNobmljYWwgbGF5ZXJzLCBhbmQgdGhlIGNoYWxsZW5nZXMgdGhh
dCBuZWVkIHRvIGJlIHNvbHZlZCBpbiBvcmRlcg0KPiB0byBoYXZlIGZ1bGwgQ2FyZXRha2VyIHN1
cHBvcnQgd2l0aGluIHRoZSBrZXJuZWwuDQo+DQo+IFNvbWUgb2YgdGhlIGFyY2gvKiBjaGFuZ2Vz
IGR1cGxpY2F0ZSBzbWFsbCBoZWxwZXJzIChzdWNoIGFzIEdJQ3YzIGxpc3QNCj4gcmVnaXN0ZXIg
YWNjZXNzb3JzIG9yIGxvdy1sZXZlbCBWTUNTL1ZNQ0Ivc3lzcmVnIGhlbHBlcnMpIHRoYXQgY291
bGQgYmUNCj4gc2hhcmVkIHdpdGggZXhpc3RpbmcgS1ZNL2FyY2ggY29kZSBpZiB0aG9zZSByb3V0
aW5lcyBhbmQgdGhlaXIgY2FsbGVlcw0KPiBhcmUgbW92ZWQgdG8gc3RhdGljIGlubGluZXMgb3Ig
YW5ub3RhdGVkIHdpdGggX19jcHVfcHJlc2VydmVkX3RleHQgKGFuZA0KPiBidWlsdCB3aXRob3V0
IGZ0cmFjZS9LQVNBTi9wZXItQ1BVIHJlZmVyZW5jZXMsIGFzIGVuZm9yY2VkIGJ5IG9ianRvb2wN
Cj4gYW5kIG1vZHBvc3QpLiBUbyBhdm9pZCBzcHJpbmtsaW5nIF9fY3B1X3ByZXNlcnZlZF90ZXh0
IGFubm90YXRpb25zDQo+IGFjcm9zcyBjb3JlIGFyY2gvKiBmaWxlcyBpbiB0aGlzIFBvQywgdGhv
c2UgaGVscGVycyBhcmUga2VwdCBsb2NhbCB0bw0KPiBjYXJldGFrZXIuYyBmb3Igbm93IGFuZCBj
YW4gYmUgY29uc29saWRhdGVkIHdoZW4gaW5kaXZpZHVhbCBwbGF0Zm9ybQ0KPiBzdXBwb3J0IGlz
IHVwc3RyZWFtZWQuDQo+DQo+IFRoZSBzZXJpZXMgaXMgc3RydWN0dXJlZCBpbnRvIGF0IGxlYXN0
IDggd29ya3N0cmVhbXMgdGhhdCB3aWxsIGJlDQo+IGRpc2N1c3NlZCBhbmQgd29ya2VkIG9uIHNl
cGFyYXRlbHk6DQo+DQo+IDEuIFdvcmtzdHJlYW0gMTogUHJlcGFyYXRpb24gUGF0Y2hlcyAoUGF0
Y2hlcyAwMS0wNikNCj4gICAgIEFyY2hpdGVjdHVyZS1uZXV0cmFsIGFuZCBhcmNoLXNwZWNpZmlj
IHByZXBhcmF0b3J5IGNsZWFudXBzIChpbg0KPiAgICAgZnV0dXJlIHRoZXNlIGNvdWxkIGJlIGJ1
bmRsZWQgd2l0aCB0aGUgd29ya3N0cmVhbXMgdGhhdCByZXF1aXJlIHRoZXNlDQo+ICAgICBjaGFu
Z2VzKToNCj4gICAgICAgMDEuIEtWTTogbHVvOiBEZWxlZ2F0ZSBWTSBjcmVhdGlvbiB0eXBlIHRv
IGt2bV9hcmNoX3ZtX2x1b19wcmVzZXJ2ZQ0KPiAgICAgICAwMi4gS1ZNOiBhcm02NDogU3BsaXQg
ZGVtdXhfYzE1X3tnZXQsc2V0fV92YWwgZnJvbSB1c2Vyc3BhY2UNCj4gICAgICAgICAgIGFjY2Vz
c29ycw0KPiAgICAgICAwMy4gS1ZNOiBhcm02NDogU3BsaXQga3ZtX3N5c19yZWdfe2dldCxzZXR9
X3VzZXIgZnJvbSBrZXJuZWwNCj4gICAgICAgICAgIGFjY2Vzc29ycw0KPiAgICAgICAwNC4geDg2
L21tL2lkZW50X21hcDogQWRkIGZvcmNlX3B0ZSB0byBzdXBwb3J0IDRLIFBURSBpZGVudGl0eQ0K
PiAgICAgICAgICAgbWFwcGluZ3MNCj4gICAgICAgMDUuIGFybTY0OiBtbTogQWRkIHRyYW5zX3Bn
ZF9tYXBfcmFuZ2UoKSBzdXBwb3J0DQo+ICAgICAgIDA2LiB4ODYvc21wOiBTa2lwIG9mZmxpbmUg
Q1BVcyBmb3IgUkVCT09UX1ZFQ1RPUiBpbg0KPiAgICAgICAgICAgbmF0aXZlX3N0b3Bfb3RoZXJf
Y3B1cygpDQo+DQo+IDIuIFdvcmtzdHJlYW0gMjogSW4tS2VybmVsIEluLVJBTSB2Q1BVIFN0YXRl
IFByZXNlcnZhdGlvbiB2aWEgTFVPDQo+ICAgICAoUGF0Y2hlcyAwNy0xMCkNCj4gICAgIEFsbG93
cyBwZXJmb3JtaW5nIHN1c3BlbmQvcmVzdW1lLXR5cGUgcHJlc2VydmF0aW9uIGFjcm9zcyBrZXhl
Yw0KPiAgICAgd2l0aG91dCBjYXJyeWluZyB0aGUgdkNQVSBpbnRlcm5hbCBzdGF0ZSBpbiB0aGUg
Vk1NIGluIHVzZXJzcGFjZSwNCj4gICAgIGtlZXBpbmcgYWxsIHZDUFUgc3RhdGUgaW4ta2VybmVs
Og0KPiAgICAgICAwNy4gS1ZNOiBsdW86IFN1cHBvcnQgdkNQVSBmaWxlIHByZXNlcnZhdGlvbiBh
Y3Jvc3MgbGl2ZSB1cGRhdGVzDQo+ICAgICAgIDA4LiBLVk06IHg4NjogQWRkIHg4NiB2Q1BVIExV
TyBwcmVzZXJ2YXRpb24gQUJJIGFuZCByZWdpc3Rlcg0KPiAgICAgICAgICAgaGVscGVycw0KPiAg
ICAgICAwOS4gS1ZNOiB4ODY6IEltcGxlbWVudCBhcmNoaXRlY3R1cmFsIHZDUFUgc3RhdGUgcHJl
c2VydmF0aW9uIHZpYQ0KPiAgICAgICAgICAgTFVPDQo+ICAgICAgIDEwLiBLVk06IGFybTY0OiBJ
bXBsZW1lbnQgYXJjaGl0ZWN0dXJhbCB2Q1BVIHN0YXRlIHByZXNlcnZhdGlvbiB2aWENCj4gICAg
ICAgICAgIExVTw0KPg0KPiAzLiBXb3Jrc3RyZWFtIDM6IFBoeXNpY2FsIENQVSBQcmVzZXJ2YXRp
b24gQ29yZSAmIHg4NiBTdXBwb3J0DQo+ICAgICAoUGF0Y2hlcyAxMS0yNCkNCj4gICAgIEludHJv
ZHVjZXMgdGhlIHBoeXNpY2FsIENQVSBwcmVzZXJ2YXRpb24gc3Vic3lzdGVtIChjcHVfcHJlc2Vy
dmUpLA0KPiAgICAgbGlua2VyIHNlY3Rpb25zICgudGV4dC5jcHVfcHJlc2VydmVkLCAuZGF0YS5j
cHVfcHJlc2VydmVkKSB3aXRoDQo+ICAgICBidWlsZC10aW1lIHNlY3Rpb24gaXNvbGF0aW9uIGNo
ZWNrcyBpbiBtb2Rwb3N0IGFuZCBvYmp0b29sLCBpc29sYXRlZA0KPiAgICAgdHJhbnNpdGlvbiBw
YWdlIHRhYmxlIG1hbmFnZW1lbnQgKHN0cnVjdCBjcHVfcHJlc2VydmVkX2FzKSwgYW5kIHN5c2Zz
DQo+ICAgICBpbnRlcmZhY2VzLiBBbGxvd3MgYm9vdGluZyB0aGUgbWFjaGluZSB3aXRoIHNvbWUg
Q1BVcyByZW1vdmVkIGZyb20NCj4gICAgIHRoZSBPUyBzY2hlZHVsZXIsIGFuZCBwcm92aWRlcyBp
bmZyYXN0cnVjdHVyZSBmb3IgZXhlY3V0aW5nIG9ycGhhbmVkDQo+ICAgICBqb2JzIG9uIHN1Y2gg
Q1BVczoNCj4gICAgICAgMTEuIGxpdmV1cGRhdGU6IERlZmluZSBDUFUgcHJlc2VydmF0aW9uIGxp
bmtlciBzZWN0aW9ucw0KPiAgICAgICAxMi4gbGl2ZXVwZGF0ZTogQWRkIGxpdmV1cGRhdGVfc2Vz
c2lvbl9uYW1lKCkgaGVscGVyDQo+ICAgICAgIDEzLiBjcHVfcHJlc2VydmU6IEFkZCBwaHlzaWNh
bCBDUFUgcHJlc2VydmF0aW9uIEFCSSBhbmQgY29yZSBBUEkNCj4gICAgICAgICAgIGhlYWRlcnMN
Cj4gICAgICAgMTQuIGNwdV9wcmVzZXJ2ZTogQWRkIGNvcmUgcGh5c2ljYWwgQ1BVIHByZXNlcnZh
dGlvbiBzdGF0ZSBhbmQgcGFyaw0KPiAgICAgICAgICAgbG9vcA0KPiAgICAgICAxNS4gY3B1X3By
ZXNlcnZlOiBBZGQgcGh5c2ljYWwgQ1BVIHByZXNlcnZhdGlvbiBsaWZlY3ljbGUgYW5kIGJ1aWxk
DQo+ICAgICAgICAgICBydWxlcw0KPiAgICAgICAxNi4gbGl2ZXVwZGF0ZTogY3B1X3ByZXNlcnZl
OiBBZGQgc3lzZnMgaW50ZXJmYWNlDQo+ICAgICAgIDE3LiBsaXZldXBkYXRlOiBjcHVfcHJlc2Vy
dmU6IEFkZCBpc29sYXRlZCBhZGRyZXNzIHNwYWNlIG1hbmFnZW1lbnQNCj4gICAgICAgICAgIEFQ
SQ0KPiAgICAgICAxOC4gbGl2ZXVwZGF0ZTogY3B1X3ByZXNlcnZlOiBBZGQgTFVPIGZpbGUgaGFu
ZGxlciBmb3IgcHJlc2VydmVkDQo+ICAgICAgICAgICBwaHlzaWNhbCBDUFVzDQo+ICAgICAgIDE5
LiB4ODY6IGxpdmV1cGRhdGU6IEFkZCBsb3ctbGV2ZWwgcGh5c2ljYWwgQ1BVIHByZXNlcnZhdGlv
bg0KPiAgICAgICAgICAgYXNzZW1ibHkNCj4gICAgICAgMjAuIHg4NjogbGl2ZXVwZGF0ZTogQWRk
IHBoeXNpY2FsIENQVSBwcmVzZXJ2YXRpb24gY29udGV4dCBhbmQgcGFnZQ0KPiAgICAgICAgICAg
dGFibGUgc3VwcG9ydA0KPiAgICAgICAyMS4gc2VsZnRlc3RzOiBsaXZldXBkYXRlOiBBZGQgcGh5
c2ljYWwgQ1BVIHByZXNlcnZhdGlvbiB1bml0IHRlc3RzDQo+ICAgICAgIDIyLiBzZWxmdGVzdHM6
IGxpdmV1cGRhdGU6IEFkZCBwaHlzaWNhbCBDUFUgcHJlc2VydmF0aW9uIGxpdmUNCj4gICAgICAg
ICAgIHVwZGF0ZSB0ZXN0cw0KPiAgICAgICAyMy4gRG9jdW1lbnRhdGlvbjogbGl2ZXVwZGF0ZTog
QWRkIHBoeXNpY2FsIENQVSBwcmVzZXJ2YXRpb24NCj4gICAgICAgICAgIGRvY3VtZW50YXRpb24N
Cj4gICAgICAgMjQuIE1BSU5UQUlORVJTOiBBZGQgZW50cnkgZm9yIEtWTSBDYXJldGFrZXINCj4N
Cj4gNC4gV29ya3N0cmVhbSA0OiBBUk02NCBTdXBwb3J0IGZvciBQaHlzaWNhbCBDUFUgUHJlc2Vy
dmF0aW9uIChQYXRjaCAyNSkNCj4gICAgIEVuYWJsZXMgcGh5c2ljYWwgQ1BVIHByZXNlcnZhdGlv
biBvbiBBUk02NCB1c2luZyBpc29sYXRlZCB0cmFuc2l0aW9uDQo+ICAgICBwYWdlIHRhYmxlcyAo
dHJhbnNfcGdkX21hcF9yYW5nZSgpKSwgY2FjaGUgbWFpbnRlbmFuY2UgdG8gUG9DLCBhbmQNCj4g
ICAgIEdJQ3YzIHJlZGlzdHJpYnV0b3IgU0dJIHdha2UgaGVscGVyczoNCj4gICAgICAgMjUuIGFy
bTY0OiBsaXZldXBkYXRlOiBBZGQgc3VwcG9ydCBmb3IgcGh5c2ljYWwgQ1BVIHByZXNlcnZhdGlv
bg0KPg0KPiA1LiBXb3Jrc3RyZWFtIDU6IE9uLUNvcmUgU2NoZWR1bGluZyBGcmFtZXdvcmsgKG9u
Y29yZSkgKFBhdGNoZXMgMjYtMjcpDQo+ICAgICAoTm90ZTogVGhpcyBsYXllciBzaXRzIGJldHdl
ZW4gY3B1X3ByZXNlcnZlIGFuZCB0aGUgS1ZNIENhcmV0YWtlciBhbmQNCj4gICAgIEtlcm5lbCBD
YXJldGFrZXIgKEZ1dHVyZSBXb3JrIGZvciBPcnBoYW5lZCBQcm9jZXNzZXMpKQ0KPiAgICAgUHJv
dmlkZXMgYSBydW5xdWV1ZSBhbmQgdGltZS1zbGljZSBzY2hlZHVsaW5nIGZyYW1ld29yaw0KPiAg
ICAgKGtlcm5lbC9saXZldXBkYXRlL29uY29yZS5jKSB0aGF0IG11bHRpcGxleGVzIHByZXNlcnZl
ZCB3b3JrbG9hZHMNCj4gICAgIG9udG8gcHJlc2VydmVkIHBoeXNpY2FsIENQVXMgZHVyaW5nIHRo
ZSBrZXhlYyBibGFja291dCB3aW5kb3c6DQo+ICAgICAgIDI2LiBvbmNvcmU6IEFkZCBvbi1jb3Jl
IEtITyBBQkkgYW5kIHB1YmxpYyBmcmFtZXdvcmsgaGVhZGVycw0KPiAgICAgICAyNy4gb25jb3Jl
OiBJbXBsZW1lbnQgb24tY29yZSBzZXNzaW9uIGxpZmVjeWNsZSBhbmQgc2NoZWR1bGluZyBsb29w
DQo+DQo+IDYuIFdvcmtzdHJlYW0gNjogS1ZNIENhcmV0YWtlciBDb3JlICYgSW50ZWwgVk1YIFN1
cHBvcnQNCj4gICAgIChQYXRjaGVzIDI4LTM5KQ0KPiAgICAgSW50cm9kdWNlcyB0aGUgS1ZNIENh
cmV0YWtlciBleGVjdXRpb24gZW5naW5lICh2aXJ0L2t2bS9jYXJldGFrZXIuYyksDQo+ICAgICB2
Q1BVIGRldGFjaC9hdHRhY2gvY2FuY2VsIGxpZmVjeWNsZSwgb3B0aW9uYWwgY3Jvc3Mta2V4ZWMg
ZXhlY3V0aW9uDQo+ICAgICB0ZWxlbWV0cnkgYW5kIGRlYnVnZnMgcmVwb3J0aW5nLCB4ODYgVERQ
IE1NVSBLSE8gcGFnZSB0YWJsZQ0KPiAgICAgcHJlc2VydmF0aW9uLCB4ODYgY29tbW9uIENhcmV0
YWtlciBydW50aW1lIChMQVBJQyB0aW1lciBpbmplY3Rpb24sDQo+ICAgICBWTS1leGl0IGRpc3Bh
dGNoLCBpbnN0cnVjdGlvbiBkZWNvZGluZyksIGFuZCB0aGUgSW50ZWwgVk1YIENhcmV0YWtlcg0K
PiAgICAgYmFja2VuZDoNCj4gICAgICAgMjguIEtWTTogY2FyZXRha2VyOiBBZGQgQ2FyZXRha2Vy
IGNvbnRyb2wgYmxvY2sgYW5kIGFyY2hpdGVjdHVyZQ0KPiAgICAgICAgICAgb3BzIGhlYWRlcnMN
Cj4gICAgICAgMjkuIEtWTTogY2FyZXRha2VyOiBJbXBsZW1lbnQgQ2FyZXRha2VyIHNlc3Npb24g
bWVtb3J5IG1hcHBpbmcNCj4gICAgICAgICAgIGhlbHBlcnMNCj4gICAgICAgMzAuIEtWTTogY2Fy
ZXRha2VyOiBJbnRlZ3JhdGUgQ2FyZXRha2VyIHZDUFUgZGV0YWNoLCBhdHRhY2gsIGFuZA0KPiAg
ICAgICAgICAgY2FuY2VsIHdpdGggS1ZNDQo+ICAgICAgIDMxLiBLVk06IGNhcmV0YWtlcjogQWRk
IGdlbmVyaWMgS0hPIEFCSSB0ZWxlbWV0cnkgYW5kIGRlYnVnZnMNCj4gICAgICAgICAgIHJlcG9y
dGluZw0KPiAgICAgICAzMi4gS1ZNOiB4ODY6IEFkZCBURFAgTU1VIEtITyBwcmVzZXJ2YXRpb24g
aGVscGVycw0KPiAgICAgICAzMy4gS1ZNOiB4ODY6IEFkZCBDYXJldGFrZXIgeDg2IEtITyBBQkkg
YW5kIHJ1bnRpbWUgY29udGV4dCBoZWFkZXJzDQo+ICAgICAgIDM0LiBLVk06IHg4NjogSW1wbGVt
ZW50IENhcmV0YWtlciBMQVBJQyB0aW1lciBhbmQgaW50ZXJydXB0DQo+ICAgICAgICAgICBpbmpl
Y3Rpb24NCj4gICAgICAgMzUuIEtWTTogeDg2OiBJbXBsZW1lbnQgQ2FyZXRha2VyIFZNLWV4aXQg
ZGlzcGF0Y2ggYW5kIGluc3RydWN0aW9uDQo+ICAgICAgICAgICBkZWNvZGVycw0KPiAgICAgICAz
Ni4gS1ZNOiB4ODY6IEltcGxlbWVudCBDYXJldGFrZXIgcnVuIGxvb3AgYW5kIExVTyBkZXRhY2gv
YXR0YWNoDQo+ICAgICAgICAgICBsaWZlY3ljbGUNCj4gICAgICAgMzcuIEtWTTogVk1YOiBBZGQg
Q2FyZXRha2VyIFZNWCBhc3NlbWJseSBndWVzdCBlbnRyeS9leGl0IHJvdXRpbmUNCj4gICAgICAg
ICAgIGFuZCBoZWxwZXJzDQo+ICAgICAgIDM4LiBLVk06IFZNWDogSW1wbGVtZW50IENhcmV0YWtl
ciBWTVggVk1DUyBsaWZlY3ljbGUgYW5kIGV4aXQNCj4gICAgICAgICAgIGRpc3BhdGNoDQo+ICAg
ICAgIDM5LiBLVk06IFZNWDogSW50ZWdyYXRlIENhcmV0YWtlciBWTVggZGV0YWNoIHNlcmlhbGl6
YXRpb24gYW5kIEtWTQ0KPiAgICAgICAgICAgcmVnaXN0cmF0aW9uDQo+DQo+IDcuIFdvcmtzdHJl
YW0gNzogS1ZNIENhcmV0YWtlciBmb3IgQU1EIFNWTSAoUGF0Y2hlcyA0MC00MSkNCj4gICAgIElt
cGxlbWVudHMgdGhlIEFNRCBTVk0gQ2FyZXRha2VyIGJhY2tlbmQgKGNhcmV0YWtlcl92bWVudGVy
LlMsIFZNQ0INCj4gICAgIGxpZmVjeWNsZSwgZXhpdCBkZWNvZGluZywgYW5kIG5leHQtUklQIHN5
bmMpOg0KPiAgICAgICA0MC4gS1ZNOiBTVk06IEFkZCBDYXJldGFrZXIgU1ZNIGFzc2VtYmx5IGd1
ZXN0IGVudHJ5L2V4aXQgcm91dGluZQ0KPiAgICAgICA0MS4gS1ZNOiBTVk06IEltcGxlbWVudCBD
YXJldGFrZXIgU1ZNIFZNQ0IgbGlmZWN5Y2xlIGFuZCBleGl0DQo+ICAgICAgICAgICBkaXNwYXRj
aA0KPg0KPiA4LiBXb3Jrc3RyZWFtIDg6IEtWTSBDYXJldGFrZXIgZm9yIEFSTTY0IChQYXRjaGVz
IDQyLTQ2KQ0KPiAgICAgSW1wbGVtZW50cyB0aGUgQVJNNjQgVkhFIENhcmV0YWtlciBiYWNrZW5k
IChjYXJldGFrZXJfdm1lbnRlci5TLA0KPiAgICAgRUwyIGV4Y2VwdGlvbiB2ZWN0b3JzLCBHSUN2
MyBDUFUgaW50ZXJmYWNlICYgYXJjaCB0aW1lciBlbXVsYXRpb24sDQo+ICAgICBzeXN0ZW0gcmVn
aXN0ZXIgdHJhcCBoYW5kbGluZywgYW5kIFN0YWdlLTIgZmF1bHQgaGFuZGxpbmcpOg0KPiAgICAg
ICA0Mi4gS1ZNOiBhcm02NDogQWRkIENhcmV0YWtlciBhcm02NCBLSE8gQUJJIGFuZCBydW50aW1l
IGNvbnRleHQNCj4gICAgICAgICAgIGhlYWRlcnMNCj4gICAgICAgNDMuIEtWTTogYXJtNjQ6IEFk
ZCBDYXJldGFrZXIgRUwyIGV4Y2VwdGlvbiB2ZWN0b3JzIGFuZCBndWVzdA0KPiAgICAgICAgICAg
ZW50cnkvZXhpdCBhc3NlbWJseQ0KPiAgICAgICA0NC4gS1ZNOiBhcm02NDogSW1wbGVtZW50IENh
cmV0YWtlciBHSUN2MyBDUFUgaW50ZXJmYWNlIGFuZCBhcmNoDQo+ICAgICAgICAgICB0aW1lciBl
bXVsYXRpb24NCj4gICAgICAgNDUuIEtWTTogYXJtNjQ6IEltcGxlbWVudCBDYXJldGFrZXIgc3lz
dGVtIHJlZ2lzdGVyIHRyYXAgYW5kDQo+ICAgICAgICAgICBleGNlcHRpb24gaGFuZGxlcnMNCj4g
ICAgICAgNDYuIEtWTTogYXJtNjQ6IEltcGxlbWVudCBDYXJldGFrZXIgdkNQVSBydW4gbG9vcCBh
bmQgTFVPDQo+ICAgICAgICAgICBkZXRhY2gvYXR0YWNoIGxpZmVjeWNsZQ0KPg0KPiBBcmNoaXRl
Y3R1cmFsIERlc2lnbiBMYXllcnMNCj4gPT09PT09PT09PT09PT09PT09PT09PT09PT09DQo+IFRo
ZSBPcnBoYW5WTSBhcmNoaXRlY3R1cmUgaXMgbGF5ZXJlZCBzbyB0aGF0IGVhY2ggc3Vic3lzdGVt
IGhhcyB6ZXJvDQo+IHVwd2FyZCBzeW1ib2wgZGVwZW5kZW5jaWVzOg0KPg0KPiAgICArLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0rDQo+ICAgIHwgTGF5ZXIgNDogS1ZNIENhcmV0YWtlciBFbmdpbmUgKHZpcnQva3ZtL2Nh
cmV0YWtlci5jICsgYXJjaC9rdm0vKikgIHwNCj4gICAgfCAgIC0gVk1FTlRFUi9WTVJVTi9FUkVU
IGd1ZXN0IGV4ZWN1dGlvbiBsb29wICAgICAgICAgICAgICAgICAgICAgICAgfA0KPiAgICB8ICAg
LSBIYW5kbGluZyBvZiB0aW1lciBwcmVlbXB0aW9uLCBITFQvV0ZJLCBNU1Ivc3lzcmVnIHRyYXBz
ICAgICAgICB8DQo+ICAgIHwgICAtIFlpZWxkIG9uIHVuaGFuZGxlZCBJL08gb3IgU3RhZ2UtMiBN
TUlPIGZhdWx0cyAgICAgICAgICAgICAgICAgIHwNCj4gICAgKy0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tKw0KDQoNCkkg
aGFkIGEgc3VwZXJmaWNpYWwgbG9vayBhdCB0aGUgY29kZSBvbmx5LCBidXQgaXQgbG9va2VkIGxp
a2Ugd2UncmUgbm90IA0KcmV1c2luZyBhbnkgb2YgdGhlIGV4aXN0aW5nIEtWTSBjb2RlIGZvciBl
bnRyeSBvciBleGl0IGhhbmRsaW5nLiBJIHdhcyANCmhvcGluZyB3ZSBjb3VsZCByZWZhY3RvciBz
b21lIGJpdHMgb2YgS1ZNIGNvZGUgaW50byBmdW5jdGlvbmFsaXR5IHRoYXQgDQppcyBzYWZlIHN0
YW5kLWFsb25lIGFuZCBmdW5jdGlvbmFsaXR5IHRoYXQgZG9lcyByZXF1aXJlIHRoZSBsYXJnZXIg
DQprZXJuZWwgZWNvc3lzdGVtLCB0aGVuIGFubm90YXRlIHRoZSBzdGFuZC1hbG9uZSBvbmVzIGFz
IGNhcmV0YWtlciAoYnR3LCANCmFiYnJldmlhdGluZyBhcyBrdm1jdCB3b3VsZCBzaG9ydGVuIHlv
dXIgZnVuY3Rpb24gbmFtZXMgc2lnbmlmaWNhbnRseSANCjopKSBhbmQgdGhlbiBjb25zdW1lIHRo
ZW0gZnJvbSBib3RoIGNvbnRleHRzLg0KDQpEbyB5b3UgaGF2ZSBhbnkgdGltaW5nIG1lYXN1cmVt
ZW50cyBmb3IgdGhlIGFwcHJvYWNoIGFzIGlzPw0KDQpBbHNvLCB5b3VyIHBhdGNoIHNldCBpcyBj
dXQgb2ZmIGF0IDM5LzQ2LiBJIHdhcyB2ZXJ5IGN1cmlvdXMgdG8gc2VlIGhvdyANCnlvdSBkZWFs
IHdpdGggdkdJQyBhbmQgY29udGV4dCBzd2l0Y2hpbmcgaW4gdGhlIGNhcmV0YWtlciBlbnZpcm9u
bWVudCA6KS4NCg0KDQpBbGV4DQo=
