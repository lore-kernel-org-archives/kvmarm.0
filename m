Received: from fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.28.197.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B4A31714C;
	Fri, 17 Jul 2026 13:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.28.197.132
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784296109; cv=fail; b=YHtBkPX1tGsAFZKf7VuYg+QrTNiSMVyeU3i8zPFswhPBWP8VPYCYflaCUkGhipGr/lnlVJyfarmFpxGQOLtRp73gceKH9f/0zYSJRszyVfbMqbpJdjGzgyweBs9gca/u/id5greIm42/xfo2E/+/KknRB3eEKD02gH7k+R1/Gqw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784296109; c=relaxed/simple;
	bh=0/NSxhPVPSKPXrawAkI0BkvVdUO4MLGmt42FLK5ZlnA=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RwSAhZsq3MgIjEZLBk0tTRir3Gl2mUzzq87+VXDdSdKpDc36WzoDJKw/Oe+42IGwEKgOju9RUUF/aPGcwAEP7aYu/Pde7i8GdJJfNf3q/yOl+3PH8l/cV8qsdbGaxDH4EZYQYnObsFQPAPXsXEnwqFV+rQ1JhjAKW5bmdoFVDT8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.es; spf=pass smtp.mailfrom=amazon.es; dkim=pass (2048-bit key) header.d=amazon.es header.i=@amazon.es header.b=HYjwEXqZ; arc=fail smtp.client-ip=52.28.197.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.es
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.es
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.es header.i=@amazon.es header.b="HYjwEXqZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.es; i=@amazon.es; q=dns/txt; s=amazoncorp2;
  t=1784296107; x=1815832107;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=0/NSxhPVPSKPXrawAkI0BkvVdUO4MLGmt42FLK5ZlnA=;
  b=HYjwEXqZjOE4VDYg8AFIIyiiJp+IUl6YSiQvYBPz5vG9oC/RiA/f+vGv
   cx+mVfoQN/RUWhQkYU/qjqT11EaznJXImC68YWZm4DjjqbBfX2Rps30mm
   dXD81lu4ixsvEFoTSdsXhNfP4Srt59yUT7Ze40ELdTDOlgif3F5Ah3xQm
   DXPC6wSJbmTpWwKq+R6n4MD0HdFomOIfGDaKlzvEcTwsoX7nRmRpVVKhe
   /+vGVxsTEr5QwGKdSGVVHIv7q4r/6HIxcm/2F5c+NyBVAj8JeCorGjSJg
   3nYG7K5EBgzAcKhDSKOwgnGfzs4CcZtKSZoU+XZoogJeF8zfXkCpJ7Ana
   A==;
X-CSE-ConnectionGUID: ffxLw/CSQYmki01J6aoj8w==
X-CSE-MsgGUID: GMKc+tU2QpSDxesJnbu8lg==
X-IronPort-AV: E=Sophos;i="6.25,169,1779148800"; 
   d="scan'208";a="16497798"
Subject: Re: [PATCH 35/60] kvm: Add VCPU plane-scheduling state and helpers
Thread-Topic: [PATCH 35/60] kvm: Add VCPU plane-scheduling state and helpers
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 13:48:23 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:18057]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.14.105:2525] with esmtp (Farcaster)
 id b51f2503-2158-4161-8710-f82c568e0d12; Fri, 17 Jul 2026 13:48:23 +0000 (UTC)
X-Farcaster-Flow-ID: b51f2503-2158-4161-8710-f82c568e0d12
Received: from EX19EXOEUC002.ant.amazon.com (10.252.51.145) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Fri, 17 Jul 2026 13:48:23 +0000
Received: from EX19EXOEUA002.ant.amazon.com (10.252.50.139) by
 EX19EXOEUC002.ant.amazon.com (10.252.51.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Fri, 17 Jul 2026 13:48:22 +0000
Received: from GV1PR07CU001.outbound.protection.outlook.com (10.252.51.199) by
 EX19EXOEUA002.ant.amazon.com (10.252.50.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43
 via Frontend Transport; Fri, 17 Jul 2026 13:48:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BrxyVp1wEarYXoTihUtp2eAlv+ZiKLy7ByZD51kM24vP+d+dzPw/BgNHPdoOrWv8Dx8oMwosE+ijn5I8XkSSdeX7KxwzZYvceoByw1Q1Tmi3xw5jfcIz4qE/PBTeacI+i90Y/d634qYY0OwtiW1CVRND3Ot3G32xFWQZWPvPEGd9I6nh7j6KYk7q9deRAIJUBXT3EuPS6sXMogwLYREy/sHjJvfBq9WR5IscrcaB8nO1OhABM5c6NisJm6RX1+uWHRplsOn5QHN0DMim9dU8UGX+oqWiVftpKYtJ2YWXU7JejJ6ylFfwZfCa7nHnbQP/NuGf4Z0BgbZpPHJ+TNQUdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0/NSxhPVPSKPXrawAkI0BkvVdUO4MLGmt42FLK5ZlnA=;
 b=DkJw8osM05fGPlQUNLhAt/U6wAItvdQAZbF2TMEwSdU9XrTwOnBv9iIQPAfJY/QF/3D1R6TJWqXvhwTNuCEYB3GGx3EgnVG0JYog0LiZRLWQ6jPunt1OSZzF3lokxcu6tBVw6WZvD/pJZNvY1+AewnVxbT1Uv96Vtl79RrNzAtoV2eyTSyn3ag1wTki1h0JWZNknMFpeKfmD7WuMueZYhXEV0HQuekrRvUfOYqDtER5gsnT+SnnUbT+yuvXgUeoqzay6i+IObaQ9fEiLMmc/m7ExvlBYatRimBniWfg8AXZlM/fXt3uSvJbeBNxcEFWMmNENFJ8cErXbW8ru/k483w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.es; dmarc=pass action=none header.from=amazon.es;
 dkim=pass header.d=amazon.es; arc=none
Received: from AM0PR06MB10511.eurprd06.prod.outlook.com (2603:10a6:20b:700::7)
 by DB9PR06MB7755.eurprd06.prod.outlook.com (2603:10a6:10:261::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Fri, 17 Jul
 2026 13:48:20 +0000
Received: from AM0PR06MB10511.eurprd06.prod.outlook.com
 ([fe80::9834:3241:1f23:20ed]) by AM0PR06MB10511.eurprd06.prod.outlook.com
 ([fe80::9834:3241:1f23:20ed%6]) with mapi id 15.21.0223.011; Fri, 17 Jul 2026
 13:48:20 +0000
From: "Saenz Julienne, Nicolas" <nsaenz@amazon.es>
To: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: Sean Christopherson <seanjc@google.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "Saenz Julienne, Nicolas"
	<nsaenz@amazon.es>, "Orazgaliyeva, Anel" <anelkz@amazon.de>,
	"James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>, Melody Wang <huibo.wang@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "loongarch@lists.linux.dev"
	<loongarch@lists.linux.dev>, "linux-mips@vger.kernel.org"
	<linux-mips@vger.kernel.org>, "linuxppc-dev@lists.ozlabs.org"
	<linuxppc-dev@lists.ozlabs.org>, "kvm-riscv@lists.infradead.org"
	<kvm-riscv@lists.infradead.org>, "x86@kernel.org" <x86@kernel.org>,
	"coconut-svsm@lists.linux.dev" <coconut-svsm@lists.linux.dev>,
	"joerg.roedel@amd.com" <joerg.roedel@amd.com>
Thread-Index: AQHc91VNfGXASvbj1EW/r45M3lCQtLY03m8AgAAR8gCAAAHXgIABOIgAgDvMboA=
Date: Fri, 17 Jul 2026 13:48:20 +0000
Message-ID: <DK0W6G329B6W.2KGT7FAVSKNYS@amazon.com>
References: <20260608144252.351443-1-joro@8bytes.org>
 <20260608144252.351443-36-joro@8bytes.org>
 <e7eb0dba-790a-4644-9895-5c9a7420d7fe@redhat.com>
 <aib8n5lO6HKbLC4Y@8bytes.org>
 <CABgObfbUsDeStnZF-7oyR-W-Bvd4qTMoeUwGizgn10UTdKtZ2A@mail.gmail.com>
 <aigE2EvJyZlYDz0V@8bytes.org>
In-Reply-To: <aigE2EvJyZlYDz0V@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amazon.es;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR06MB10511:EE_|DB9PR06MB7755:EE_
x-ms-office365-filtering-correlation-id: 5c1a80db-5e2a-4fc9-c8d6-08dee40a0ffc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|38070700021|6133799003|56012099006|11063799006|10067099003|3023799007|4143699003|18002099003|22082099003;
x-microsoft-antispam-message-info: R/TJwyKvSaTXI+KlYegtP2y65+HfcnXOwffThLhYoenbzUC9G/l1lVmCUfl678xvUd5CyWs/vto4v5zOboOz/ZrzHVcb3HC8QuewAfPz/7HZzs0xCSDgcbiXVGdufO1on7TqXY12WGMY42nyEs55GrgERq+tF5kNVkteoo8M0ZSj1Q2EWZMB7Q8lEGzH/s/sY+qSq3hFt9yVg6cg5H5qmeJT1azoXJTNbVth0cxfecSVDK5WbvP/Kx+FojJBU4akmGkbUBIaH0+olBUlux+1Z4zOrfOSHynTZDxPgm/HYcvqJu0hTgzzogkZwJCrGJVVidFfnHd/IEhsrF/XoSSwWOUCQC1FtYxHqROdNe76LgfweD+mxjnFG0HPJeFQlJxi+GHzXNLj9jvGMbwRgbGqotUkljdXoo4L9/IJzcgOyLmVlZkqpmuV8JRew4Rb9wKkSnzy/BxEsgqE9WSRI26MEp572xDBNq+ITg9yb3dbv5WLlJUmKy8ddd5mWr9C6JU/GpleQyCH8c36LH7NKUZbHJHC8vfPIKvyV7nO2zKioT2Pej9sgu4aF6d5tHsRGI8I2xgBdRu0WcRVZ0MvcnNwJu3L064AQcKsLvl0NC49rmfdlj/uV+XZZWVunsRzHEKo1VBrSLmDvLlP+vTt0RAJUI22w4nOU1CD4KDc9Si6taCQQpIsBldHe/Yii1Vjb4Ks9OLEpadMIqlaI0cuyNfq1+WJ6mlF1JdajMQhbVzBX10=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR06MB10511.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(38070700021)(6133799003)(56012099006)(11063799006)(10067099003)(3023799007)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YnpJL0FHZ0c4UFdveWhkZHFkRzh3djNhaU41a1kyU2lLMXpVZEJFaktIbkVo?=
 =?utf-8?B?Vmx3dkRubXM5NnhaVzNGWFRSZGViem1Jczc4eG96QzV4ekR0eWVsTDhLc21J?=
 =?utf-8?B?SzhiZUpTYmM3MGxYNi9tRGVJTURsN0p3UUMxN3owUDBzNUtIRFpmY01uUTg3?=
 =?utf-8?B?WUhLREtUbWtvZ1YySVcxbklFRGtyZVdtTmZmOURpNjBHODJRUEhsNnZ5cXpI?=
 =?utf-8?B?eU9za1RpbVczWTlpRnJhRlNKb2QzanlSOVo2M1Zzb3dRenVEMERGZWJkN20r?=
 =?utf-8?B?Wi9YcFlPVlNRRU5aSlhGSTFmWCtpMkc2M2F4TURTem9mM2VKZ3cyOGh3a3Rv?=
 =?utf-8?B?TzhiQjZ2S3BrREhvMWlHT0QxZWx5UWRrNUloVjNPNFhVQUhwZ3Z2VXRZem0x?=
 =?utf-8?B?dlVIaUw2YlhGSWhRNVR4aUp1ZURHUDFqQkJicG1hUHRVb2M3T0hIY3ZEL01G?=
 =?utf-8?B?RnNPUjhuRVV6Y0JoVzBNKytRSmM2ZllFOFd2cGdRU0N4cGtsUmhJdGhJRzIv?=
 =?utf-8?B?cDBWbktGMlhvUytPaVppb2ZyWjExaDNKcUpkTkpKeXloQnc2c1FiVmpEM3NM?=
 =?utf-8?B?OFpTMWUvR25zQXRqRCtCUU56NmFVL1dvdjVQQ2FRR1NUZ1hMOWZHUVNYcWVO?=
 =?utf-8?B?dmxENzZzOVFhalJyYk4rMWhyb3ViSlgvWFF5czFqYUFEemgzdkltbEJVOE9x?=
 =?utf-8?B?clhJTVdsdkhBbHl0bTNFeXE4ZlNJM0ZyaUttUzFiTnE5cHp5MWVTWnlGaUVu?=
 =?utf-8?B?K3VoK21qUkF0ZzRUa2ZNdUdwcnJxNUNxOUdEcVIzbFdJUmlzUElGQUJEL2Fk?=
 =?utf-8?B?THFTcktRRFQrTS9vV0NTM3FwSVdxYUJSeDdWTjN6YXdZKytsK3dmZnFYWHE4?=
 =?utf-8?B?VmpBdTVNRXVaY3ZhL1VabVJyZ3phb0FiUVpVdVp2S2trQk8vd2VXNFJXenFH?=
 =?utf-8?B?WTNYNTVYUnBaN0tQYkJlaDk5ZkdsU0RBRWhZNk1rbEdqRzZtVEhGTUlSMThz?=
 =?utf-8?B?emJFd3kyVnhuMmcrdDN3cVI4OHpQNHZ3MGVxbzlHbDd3aTlwRDJkYlRzTE5Q?=
 =?utf-8?B?Z3JHNSs0b0tIUEhyS1NVN3VmdXBodytWM2N3ZkxCWmZsek1FVDl4Y2RtTWhV?=
 =?utf-8?B?aHhpUDMxSUVaRWpOT2o2VXA3aG5PeXdxNVlJWWo5UFo3YUU2c1oyUmdSUWoz?=
 =?utf-8?B?L1FCUVRnTFpVeW9xNEl0VlFRUHpOeHYycmNvSFROZllIRG1nZ2pmelU1QWZF?=
 =?utf-8?B?UEN4Yi9KNUpVY3QrTkZ1MGd0NjF2WVk5dlFGWVBmTG9yRE4zZnpQeUJ1TWVl?=
 =?utf-8?B?UU1HbUs5b29qRVlwZTF2TmZHS0tqZ25oVW9LMjYzN09CWnplRjE5Um9McGpr?=
 =?utf-8?B?TWNuV2hXSjltcjh0Zi9Gc204TmFaeUJHb0FZM0hxMkN2UnBIVVBXak5xNXpr?=
 =?utf-8?B?RzlvSjNERmZRRU9iL201MjhoRCtFdUxSQUZwLzhWaXBIeW9GMWd2c3NxZUtU?=
 =?utf-8?B?WTJUd0ZMekRyYmFnWnpLUHFQQVY3dGVwd08rV0NLUFlsVytPY2tmaE0rRkxL?=
 =?utf-8?B?d2lxRE5PWWh3ZS9Ba2hUNnlyb1dma3VLQ1Zvd3o5U3BaTTBYbERWWkMvU1l4?=
 =?utf-8?B?R3ZJL0VkdWhpNnNJSjlvZFhSR1BEQ3lVbXBZNll2RTZwRGUzZTZSejVnTkRU?=
 =?utf-8?B?ejlwSEdvcWk4THorSkhPbmlUdXY0akV6SnlHSFBoNWd2SVhla3c3RE1XaEFS?=
 =?utf-8?B?NjhnWUJ4Tkw1TkhTTmp5VFUvWkxHN0NjRlRmMWEyMVcvbkduRTlFQm9PeWl2?=
 =?utf-8?B?MW9PUERidjZsS2taSXhLSkxxcTUvUkhNQWlpbDBLaDh2M3dKWTNQaTk1aHRt?=
 =?utf-8?B?cEJoTS9CQ2VHOWRJTEFSdmgwU2ZlTCtvcjBkNkYvdFVWY1o2Y2VyV29CZGJK?=
 =?utf-8?B?OWNma1dVVnlmMXJYeG9MSE5wdktwTFNld2FhclNZWG9QbTc0Q0g4OUZzY3gw?=
 =?utf-8?B?Y1cvMVdxT01aeGFwWGxLeU9OMEN2Mmc1SjN6YXo3N0ZMYUpYbUhpUEFQOFJY?=
 =?utf-8?B?YjZOSmZLbTNxWmtYMlJRcXc1QU5RTC84M3NnTno1c2J0R0JOSTllV1psQUR6?=
 =?utf-8?B?QnNGc1h6ZUI4SnhsM056QVJFSFFOWFh3QUZzemZIZjFQcDE0Q2F1b1UxSWtQ?=
 =?utf-8?B?ZjNJRXROUE1TTVJYWDcwTDhrdDRtOGJmckx2TVpqREI4V01qTkdwMzF1akxJ?=
 =?utf-8?B?SFRrOThtZmY2c0ExMTQ4dmVnT2c2VURrK0pjNFJDaUZpWXByOVJuVXd3eEtI?=
 =?utf-8?B?c2hLTE0yK2Z6d0E5NkRSdFk3T3ZUWFV4WTN4SkxpV3ROL2VCMmpQQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <86BB382E946B4D47846D42C274068BCF@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Z1Do9vs2/jRKBeyg2QHA5mTD0GSMWLaDaVVrSd/oVu4MQMUNGeQxUIdkxLKeCYzGopPBEgJ/wuKzk4zT0Ye7asZh6fiGVmjln97icnPQAEMzldH6l0m+hGmu8pAt6/xpGXuYaye+fNsOsUx5j9BVLGUSntY6cLbOJDgPrwFupXCETcSgJoUTUbsFUrekt8NX+S/ExSC8IZTc5QlDfAbHENMOEa73sysT05GRX/Y6XFUookfvKPF5vkJYnjtSgJfpv9CZXac47v6ZTdtXbjSlfrTCJsyOflNhAcWUoGx/ck8jAyKas6h0wmH8CeJ6Dw1rj9wm2ZrHuHZ+p7ZBHJ0LrA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR06MB10511.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c1a80db-5e2a-4fc9-c8d6-08dee40a0ffc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2026 13:48:20.1619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Aupk1F97pwjbr/CmnBMFk+8KzYfJcTgJ4mdtgY/uCgJTbCfQJOmnpNTe9LjnNAYcRxtOSNedTyik8D7bWep5UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR06MB7755
X-OriginatorOrg: amazon.es

SGkgSm9lcmcsIEknbSBhIGJpdCBsYXRlIHRvIHRoZSBkaXNjdXNzaW9uIGhvcGUgaXQgaGVscHMg
bm9uZXRoZWxlc3MsDQoNCk9uIFR1ZSBKdW4gOSwgMjAyNiBhdCAyOjM3IFBNIENFU1QsIErDtnJn
IFLDtmRlbCB3cm90ZToNCj4gQ0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0
c2lkZSBvZiB0aGUgb3JnYW5pemF0aW9uLiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRh
Y2htZW50cyB1bmxlc3MgeW91IGNhbiBjb25maXJtIHRoZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNv
bnRlbnQgaXMgc2FmZS4NCj4NCj4+IFRoZSBpZGVhIG9mIHRoZSB1c2Vyc3BhY2Ugc2NoZWR1bGlu
ZyB3YXMgdGhhdCB5b3UncmUgbm90IGZvcmNlZCB0byB1c2UNCj4+IGl0IC0gdGhlIGtlcm5lbCBj
YW4gYWx3YXlzIGNob29zZSB0byBvdmVycmlkZSBpdCBpZiBpdCdzIHVzaW5nIGFuDQo+PiBhY2Nl
bGVyYXRlZCBpbXBsZW1lbnRhdGlvbiBvZiBwbGFuZXMgKGFuZCBvZiBwbGFuZSBzd2l0Y2hpbmcp
LiBCdXQgaXQNCj4+IGFsc28gbGVhdmVzIHNvbWUgbGVld2F5IHRvIGRpZmZlcmVudCBhY2NlbGVy
YXRlZCBpbXBsZW1lbnRhdGlvbnMsIGVhY2gNCj4+IG9mIHdoaWNoIGNhbiBwaWNrIHRoZWlyIG93
biBhbGdvcml0aG0uDQo+Pg0KPj4gQ29uY2VwdHVhbGx5IEknZCByYXRoZXIga2VlcCB0aGUgcG9z
c2liaWxpdHkgb2YgdXNlcnNwYWNlIHNjaGVkdWxpbmcuDQo+PiBCdXQgbWF5YmUgaXQgZG9lc24n
dCBhZGQgbXVjaC4NCj4NCj4gTXkgcHJlZmVyZW5jZSBpcyB0byBrZWVwIHBsYW5lIHNjaGVkdWxp
bmcgYXQgb25lIHBsYWNlIChpbiB0aGUga2VybmVsKSB0byBrZWVwDQo+IGl0IHNpbXBsZS4gQnV0
IGlmIHlvdSBzZWUgYSBuZWVkIGZvciB1c2VyLW1vZGUgdG8gaW50ZXJhY3QgdGhlcmUgYXMgd2Vs
bCAob25seQ0KPiByZWFsbHkgd29ya3MgZm9yIFZTTSksIHRoZW4gSSBjYW4gYWRkIGl0Lg0KDQpU
aGUgcmVzcG9uc2liaWxpdHkgc3BsaXQgd2UgaGFkIGluIG1pbmQgd2hlbiB3ZSBidWlsdCBhIFZT
TSBlbXVsYXRpb24NCnByb3RvdHlwZSBbMV0gd2FzIHRvIGtlZXAgYWxsIFZUTCBwb2xpY2luZyBp
biB1c2VyLXNwYWNlLiBUaGlzIGluY2x1ZGVzDQpWVEwgc3dpdGNoaW5nLCBDcm9zcyBWVEwgSVBJ
cywgSW50ZXJjZXB0cyAoTWVtb3J5LCBNU1JzLCBJbnNucywgQ1BVDQpyZWdzKSwgVlRMIGF3YXJl
IFNNUCBicmluZy11cCwgZXRjLiBFdmVuIHdpdGggS1ZNIFBsYW5lcyBpbiBwbGFjZSwgbXkNCnRo
aW5raW5nIHdhcyB0byBrZWVwIGl0IGFzIHN1Y2guIFdoaWxlIGFsbCB0aGlzIGNvdWxkIGJlIGlt
cGxlbWVudGVkIGluDQp0aGUga2VybmVsLCBpbiBwcmFjdGljYWwgdGVybXMsIEkgdGhpbmsgaXQn
bGwgYmUgZWFzaWVyIHRvIGdldCBWU00NCnN1cHBvcnQgdXBzdHJlYW0gdGhlIG1vcmUgd2UgbW92
ZSB0aGUgaW1wbGVtZW50YXRpb24gaW50byB1c2VyLXNwYWNlLg0KDQpNb3JlIGltcG9ydGFudGx5
LCBJIHRoaW5rIHRoZSBhcmVhIG9mIFZpcnR1YWxpemF0aW9uIEJhc2VkIFNlY3VyaXR5DQp3b3Vs
ZCBiZW5lZml0IGZyb20gYSB2ZXJzYXRpbGUgUGxhbmVzIGltcGxlbWVudGF0aW9uLiBGb3JjaW5n
IHNwZWNpZmljDQpwbGFuZSBzd2l0Y2hpbmcgc2VtYW50aWNzIG1pZ2h0IHByZXZlbnQgdGhlIGlu
dHJvZHVjdGlvbiBWU00NCmFsdGVybmF0aXZlcyBvciBleHRlbnNpb25zLiBIZWtpIGFuZCBsVkJT
IGNvbWUgdG8gbWluZCBoZXJlLg0KDQo+IEkgcmVhZCBhIGJpdCBtb3JlIGFib3V0IFZTTSBhbmQg
aXQgc2VlbXMgdGhlaXIgcHJpb3JpdGl6YXRpb24gb2YgVlRMcyBpcyBhIGJpdA0KPiBtb3JlIGNv
bXBsaWNhdGVkLiBWVEwwIGhhcyB0aGUgbGVhc3QgcHJpdmlsZWdlcyBidXQgYm9vdHMgZmlyc3Qs
IHRoZW4gc2V0cyB1cA0KPiBWVEwxLiBCdXQgVlRMMSBpcyBvbmx5IGhpZ2hlci1wcml2aWxlZ2Vk
IG9uY2UgaXQgaXMgbG9ja2VkIGJ5IFZUTDAuIEFub3RoZXIgd2F5DQo+IHRvIGxvb2sgYXQgaXQg
aXMgdGhhdCBWVEwwIGRlLXByaW9yaXRpemVzIGl0c2VsZi4NCj4NCj4gVGhlIHBhdGNoZXMgaGVy
ZSBhcmUgYnVpbHQgYXJvdW5kIHRoZSBhc3N1bXB0aW9uIHRoYXQgcGxhbmUwIGlzIHRoZSBoaWdo
ZXN0DQo+IHByaXZpbGVnZWQgb25lIGFuZCBpcyBhbHdheXMgcnVubmFibGUuIFJ1bm5pbmcgYW55
IGxvd2VyLXByaXZpbGVnZSBwbGFuZSBtdXN0DQo+IGJlIHRyaWdnZXJlZCBieSB0aGUgZ3Vlc3Qu
IFRoaXMgaXMgY2xlYXJseSBub3Qgc3VmZmljaWVudCBmb3IgVlNNLCB0aGUgcXVlc3Rpb24NCj4g
aXMgaG93IHRvIHNvbHZlIHRoYXQuDQoNCkknZCBzdWdnZXN0IGludmVydGluZyB0aGUgcHJpb3Jp
dGllcywgd2l0aCBoaWdoZXIgcGxhbmVzIGJlaW5nIG1vcmUNCnByaXZpbGVnZWQuIEl0J2xsIG1h
a2UgaW50cm9kdWNpbmcgaGlnaGVyIHByaXZpbGVnZSBsZXZlbHMgZWFzaWVyLiBUaGlzDQppcyBl
c3BlY2lhbGx5IHVzZWZ1bCB3aXRoIFZTTSwgd2hlcmUgaXQncyBub3QgcG9zc2libGUgdG8ga25v
dyBob3cgbWFueQ0KbGV2ZWxzIHdpbGwgYmUgZW5hYmxlZCBiZWZvcmUgbGF1bmNoaW5nIHRoZSBW
TS4NCg0KPiBUaGUgYW5zd2VyIGRlcGVuZHMgb24gaG93IElSUSBkZWxpdmVyeSBhZmZlY3RzIFZU
TCBzY2hlZHVsaW5nIGluIFZTTS4gSWYgYQ0KPiBWTSBoYXMgVlRMMCAoY3VycmVudGx5IHJ1bm5p
bmcpLCBWVEwxLCBhbmQgVlRMMiAoaGlnaGVzdCBwcml2aWxlZ2UpLCBhbmQgYW4gSVJRDQo+IGJl
Y29tZWQgcGVuZGluZyBmb3IgVlRMMSwgZG9lcyBIeXBlci1WIHNjaGVkdWxlIFZUTDEgZGlyZWN0
bHkgb3IgZG9lcyBpdCBzd2l0Y2gNCj4gdG8gVlRMMiAoaGlnaGVzdCBwcml2aWxlZ2UpIGZpcnN0
IHRvIGxldCBpdCBzY2hlZHVsZSBWVEwxPw0KDQpUaGUgaHlwZXJ2aXNvciBjYW4gdHJpZ2dlciBh
IDAtPjEgc3dpdGNoIGRpcmVjdGx5IHdpdGggImludGVycnVwdCIgYXMNCnRoZSBlbnRyeSByZWFz
b24uDQoNCk5pY29sYXMNCg0KWzFdIFNlZSB0aGUgcmVwb3NpdG9yaWVzIGFuZCBicmFuY2hlcyBy
ZWZlcnJlZCB0byBoZXJlOg0KICAgIGh0dHBzOi8vZ2l0aHViLmNvbS92aWFucGwvcWVtdS1rdm0t
ZGV2LWVudg==
