Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15904BD0FB
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 13:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790601681; cv=fail; b=Is+3eHKnzy+YmWwqciSKOWzpYs8SUOhOhCHllA8q0ESbuIYFUbUVl0JpptnjTWXDYOyaNrqjwuLkrjSP+qWmQO5kbTxzrm/M24tL3yw/Eck7Zk5AuYUktCse2AwrMQ2pzHi4xt6+2IZb6znWXRTpJjHqWqQp+m2jm4p9LrxZycA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790601681; c=relaxed/simple;
	bh=dkyi2qh1zkE7n1TxPlSWSl96/QhLwPtY4txYJt8jiQc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RXariR5OyzqV2TgMO0rYBdUvPRIqyyotNM/jE2BxMYHcmkw9Br1Hgh3lOjcjvD/pa0ShvoOCfHt56XAM5cOC5+3Ft3ncUw3iJ9N9enDoBlNEWESM/z88OxWYiJqmxUaK4nyNdZ26Q38eGsp2Tu7dsw17y86ZH1aZSuLaILA/dqU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=TJt8Gecs; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=puh1QpA6; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="TJt8Gecs";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="puh1QpA6"
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBB60x1410666;
	Mon, 28 Sep 2026 06:20:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=dkyi2qh1zkE7n1TxPlSWSl96/QhLwPtY4txYJt8ji
	Qc=; b=TJt8GecsnAPbEuRoFfxLf4dvoEsKshzOwuYmDgenyDdzMCTxM5hmNWOvo
	7gDnMp9uJE8lJeGQT8cYZ3frBaCyj5Sttsb0W+e63YSCp8P7Wol0E61ev27gLcMw
	TlQEt//4WiHzK1f0ZHt/uaB2frLQ/rh6tbS6GOJMog6dKCZndyUAKT5qGwjShJ97
	pSEGv1a4Hl37kLEJgcEd96D8aF3jROKDVwqo2CuPTP15yk0bXwSttW6u4pG/tnhu
	5JmMJnzHIcagtcqPtzwdg41fLGYG169kiJtwoqZ4A9BTZNSr9nY7JMPYmlpQB8rL
	Ac55Sdc2QxdVissb0bcPPcvBUs29w==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11020082.outbound.protection.outlook.com [52.101.56.82])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4gxbk5kecv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 06:20:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vPmlbBSHgm5uCRjfKAnIbUwSp+zkb563ydRgmVMXRR+AUmwDj292qmXVVi/z80pT0c3s/gqRrazXPVILfrKk2PGoZuWIk9FjAfa/4GQrM343f8pC3wyrOYhtuwrj+NreT2/UNA66gPozSW22IS57JEqHiAq7EAWlud0JhIraL3AGWiFc2JUNfWHZAuvu/gPPr6GzD1qqlA7KcTQmDYDqNq0xgCbD3HRRY+KxxGb2l4yN6gZp/7QjoAiJ3T1w4uQvxGjlsSZmPYT1aPavhH8I3+t0tp38CWkzOHGMcE7258kRhFNcp42OWu7Q2TI1LmDiWWMwvYz3l6d67nOW6Wj1wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dkyi2qh1zkE7n1TxPlSWSl96/QhLwPtY4txYJt8jiQc=;
 b=vmw/F1ppxQ6Ayea0iK9X95oG6HUo9H4Fou0L2Z1HGTr3WQWjtz1JvObUCMtmmSTW4zpbrH8YODvlKTCl/FNSSE0DY4/ApC+afWuR4Fn7OEcCwZ5eQ1EMgU4xRxzZyhnVMgvP3gVwKgQBSOYB50CUrwpjvZpuc37GhwJRaKvBJxQNx0QDWuGutOaWAbfyZaNv9u9hRBMaiL/ehzhcFHRzPi/zgKbq9WHNmXOYZQWJiALBFbZH3ACCOyFXw4SXsZi7jrD965v4wC4zpSfCDrmkVKAFiuZaUpDfe1bJt43k2ngHT9oIG4HVgJVK9fEROBDNmzJChf+keIi8UgEoIlXFJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dkyi2qh1zkE7n1TxPlSWSl96/QhLwPtY4txYJt8jiQc=;
 b=puh1QpA6DdKc6X/6o66DiMlBid7omztu+5UimWbZ6sQP3MvFRsH5YiWc6gjpo45dCxVYuhM07qCB37J0U3xQ1sughJmaJVpUsN4IxVaLNr5aFyy3+ZyuaMb6lJe3FOdsNU0dzzNq3br9R7fdqLH2Gwysaoi+NUUNc5xt39PiyrMkF66VzE6FdQ9yoJygYiFX2BaPO5ksk0oq/ZF5agmw6wZGcrFSkSXF2+kRvcahzQ8ehUjtGDMJ8iX26pv14teUd5wzptziqkTP98wve94ZQUzFEEuV/7M5jVGXr3GlNDq3LNkBSKJIPEgm7MTcqt6LjvFqo6p/zD0ISulAM51zow==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by IA3PPF92BFC0A2A.namprd02.prod.outlook.com (2603:10b6:20f:fc02::253) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Mon, 28 Sep
 2026 13:20:47 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0451.022; Mon, 28 Sep 2026
 13:20:47 +0000
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
Subject: Re: [PATCH v9 14/26] target/arm/kvm: Implement SYSREG property setter
 and getter
Thread-Topic: [PATCH v9 14/26] target/arm/kvm: Implement SYSREG property
 setter and getter
Thread-Index: AQHdTyvA9mcebWLrrkq/kOH2eEpLs7bj4G6AgAAZhQA=
Date: Mon, 28 Sep 2026 13:20:47 +0000
Message-ID: <8FDF1B75-E523-4FFD-81A7-710D5EDDCA1D@nutanix.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
 <20260916144721.751810-15-eric.auger@redhat.com>
 <ABBAB5A1-BD41-4D5C-9D09-DD1D7C50D0FB@nutanix.com>
 <810074ff-60af-4b36-9a7b-9b5ce4117eb4@redhat.com>
In-Reply-To: <810074ff-60af-4b36-9a7b-9b5ce4117eb4@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|IA3PPF92BFC0A2A:EE_
x-ms-office365-filtering-correlation-id: 3995f3d5-bf1c-4626-3104-08df1d634ec2
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|10067099003|3023799007|18002099003|22082099003|56012099006|4143699003|38070700021;
x-microsoft-antispam-message-info:
 JlrOqWWU4wacQckiMnOuKLrg9KF7gAAsbt2gNd9hvsnk643bzgQi4MpAWjxeoff81uA7RO5kvB1w8ENH+c4gjHtorF1KILt3t/A3gM0QAlRdD4nRPJTBbwbnbC2M6qIWfGN9laWHiiiNX4FNxqH+E3TYw04CtRYZcGTeUP54LHoShHzEgVtEm/D2mIPmpyVqIzXxYO5sAXLDbOvxgsS280TI3aVj0OjGzZv0A9yffrEQW9WHpo8syzNEKqkvnhd2C+JdxfwPed3PlnnoO3RVuMTfHtDZjTiVKGwyFoXgTzH95wbXec+UVrmHajisGmvA7k0We4DJjXnGqe/3l6v0t1bqs46Uosm7yk9mPkr06DS7JE2RIZF5SigBUdqNzIhCxEuKiP4joegXUSPjNRIaAV7CNac5lMEsMrrRneSi6DNxlIfGY7SgVKRujJQEZ/FFQzUQ39iYPc+0od2NSD/mOP2Ge0pVuEH7DRHP2I9E7AzT0xpjjHA08cwpUiCfBtbLOsMgFTLN+lkOlLa9PuyL6uZQRjWsPmQ14uPUDkJpwC0M+bb6rmvdG01WR9TAw4EbSGSena9A+mHA0xFA07mbQIV6XCQ491vvNMCS9iEYpSZMtFkCnnVUGX8rCvRGP2gCns8fvwlKlk02jykRqD7e04guwqNgBuVISMys5Qpr50NztpHEDtrTvdVaUgtOS9ix6CRtzxHwBS/P/zGl6Qh5FpbIAfpekkfkWjL2Ir1y4Fw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(10067099003)(3023799007)(18002099003)(22082099003)(56012099006)(4143699003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Y2toN3c1bDZ6NWhWZTNCMlhZQ3ZUdzl0azZoU2E4S20yV25hWituYjQyc0k2?=
 =?utf-8?B?YlUwKzljaGVJa09CNmNXT2JqWFFFeXNOM3JiUkg4MEZiUlE3RTJCcEFuSVhS?=
 =?utf-8?B?R3A4WUExaG5FM2dGWlNVWUQvMHkxVzVSRHRhNkVkU3ZhRlVTYUR5WXJyRDB2?=
 =?utf-8?B?d2dqV3FtZExnV21GbGlST1hzdm9kUEtHaFdRdGYxckNGUWJ3bUZmM1U5SjZJ?=
 =?utf-8?B?OTZJYjJybit2NlNMaHBiY0ZUTlJzOVNZTm1IamlFMHhkazBYa011SzZBaytl?=
 =?utf-8?B?dXpYT1Zac1ZkTE5KN0c4MmRUSjhFeFB2Q2JXbUJWSUQ1TTdYNjg2SXh5NTRR?=
 =?utf-8?B?TVRoSGtCWGZBVGxuL2xVNjhOUE0xc1pQbGcwUmpIYkNkTTdsdGJYMFFrajZh?=
 =?utf-8?B?cjdhbW41M2YzT3M0NXNpYUxCZE1pd0g0VEhUejcyT0FLeXVJeGpyaHZ3eC95?=
 =?utf-8?B?WE1RckpvQ0M3bEEzVFNkTWZLc21zUitLYlVOVy9tdVhhNlRNQzlHMUgzRHMr?=
 =?utf-8?B?ZlVKenBOZEptRExBMkJqU2F2MURQcWFQS1ZWbFVoNmFKSzJ4c0dwaThxREkz?=
 =?utf-8?B?SVNuUzhOelcxNXAzNm44N25xZ3JrcXJBOW5pUytzV2VNd3g3eGZ0RUprVm1F?=
 =?utf-8?B?QlR4OUpNL2ZWdEc3NGp0YlUvanhFQ1k4Sno5ZTllNTREMFROUXk4eENEV3hp?=
 =?utf-8?B?NVFoU2tDTmJnemVFaUZEYUpMTnpEd2t4UUpkeW92ckRmN3VRQm9NY0IyVlkr?=
 =?utf-8?B?ellwcDNFNjdrNitpNzlydFNrWmZsM296bDUvZjczQ1pKbGhXQnNhMTB3ck8w?=
 =?utf-8?B?Zk5IUEJUSVF4bUZxUFN3ajdqdTBkQUZ2R0tzV1Fnak5OZXYrckZKUjB4azVj?=
 =?utf-8?B?SnRDeDFwS1kvS2RqNzlacTZmWWZwKzUrRCs5ZUY5ZGpieEpnN0w0SjVzM1Z4?=
 =?utf-8?B?QjVmQVJkTEFvMFB5SkdkekJNb3dicGJVZmFFcDhXSHF4QlFkWC9DUGxEMUFO?=
 =?utf-8?B?UDI2Qm9menhGdE1NeHVBcSthbWk4ZUVzTlM2c1RhZmdndU4vNklKbkdBUUVk?=
 =?utf-8?B?cDJuOUN5Q0pvT2k4ZTlXTndJYUdBYWF5NHNGdUFqZVJSR1NwWW9Cb3JUU1JR?=
 =?utf-8?B?WTUrb0xCUEphSUFhOWJ0T3lnRXQ5Tzd1U0lCYnNML1UzekkxL2ZuQUdLV2hW?=
 =?utf-8?B?NzZtd1RIYlB5QXl3UzM4b1Zub0MrNXZRQ2owb0NaSDJGSk5iVFJZR2FWM3N0?=
 =?utf-8?B?eWZXeGFTbkNHYkhkNGFPVzB1d29GQWJ2M0QwNEpZdzlRMG8xVm5wUjZzTWx6?=
 =?utf-8?B?OWRtNWk2TFBWcDFMMU5YOHlvM1VJdVZqMUJtMGtoMmtCMWpYWTNXa3FqVG5Y?=
 =?utf-8?B?UU0yL2NIejRBNnhiaFlCZVJCQUNna0lna0FrRVcyallRVHkwdFdETWExNmlQ?=
 =?utf-8?B?SDAxMDhLQzJaNHZoUjNlckUwbmViTU01Ui9xTmFWTzl1bmpjTnlLZUtTejhu?=
 =?utf-8?B?bGp5ZTZCbDAxTlJlTVVpQkViZEowOXpUL2RwWURlTXRta2g5YndzQjBqNkZV?=
 =?utf-8?B?Umw2a2xZSEVYVWZKeFQ5Y3B6Qi9ZMkcyaTNDNE9jb3Q2dkliNU5ZQ2lkckpR?=
 =?utf-8?B?Mm9IZ1NIdEFwUG1Ya01hODlaazFadHFldWkyeTBiRGFkODA2VGY1TW9HZFZh?=
 =?utf-8?B?MHA3SXR3bjJlUy9NVnkyUWVvVmFZMDFjNmJ3azdGVmFBdmRqMk5tUTBlS3hD?=
 =?utf-8?B?cGJzVW9Jb09sMG5EV0JVWEpUQlhvYlZvbDJ5SFdWY1FnVURNU2xremhIc3Zx?=
 =?utf-8?B?TEV3SmkxdUZ2RjVGWEk3c0k2V1RxTkdCU09vK0ZsQjNZdVQrUVBnMlhWckd1?=
 =?utf-8?B?K2ZUdXFiQVlWdUxrMnk1VkcrREd4MTRQbVc0QjJKYUQzKzFOUHYxNWY3RnlK?=
 =?utf-8?B?OUQ3WlB0Qit2TnR3MDFuV3BjOUdOOE56RExEV1R6QXlSdUl6L3hKSXk3aW5Q?=
 =?utf-8?B?K2ZBWFE4d25YYlBmSlJiT010M0FrTmFMMWQ1bHNQSmpwd3prN3NxZmFlZUdB?=
 =?utf-8?B?cUtwMmFRazFhbDgzTm55OVMydElVWDl3OWsrUFJ5bkxoWE4yZUYvUy9FVkkz?=
 =?utf-8?B?MU5lcTltQ1N5ZmIxWk5TNTJvaDUwOEFOTkNRTXhkTVNJczdXS2lKN2p2Zm5Y?=
 =?utf-8?B?bXAzUG9OZ3FYOXVLcnVrdUd2Y1FiM2Q3M0c2VmNxS2t2NmtoaVpEcUNjYzZp?=
 =?utf-8?B?L0VGbTRpSjlIR0YrUDlpT2dtM3VtazJ5V3VBaytxejk2VGNLbWloS092RGVw?=
 =?utf-8?B?WTlVWGs3UE92bWs1VFdzWE95UExNYWZMWVR3N0JBSkFVSHFHK01pQ1d5WFBE?=
 =?utf-8?Q?apC53wpwAibrkH/I=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5B714FF5384B874199E172AE148489DC@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	f0PAYmI959yu4vqawNTQZliOfKtZl5OkG1CGaDHsx1QFrTtMPGPXSChHhoRVF9cupMfN6d7usEbW8zXKRbUJpkwD3eOk3KsVP1LTYzlAxdZkQWd+7akYrKfn8w8gQaEmAChjqo2ACbKko3fcQJJevqNs4F3meWVWaCZB0ErSx71dbsVNzhzUVnFM9xxlUXcXo59vud1HNnHGmNkmSluPJYfUqTP0D3+CETs1AziAryYQsPI5uFhTAT3KOG5zPrHA6NHNb1hALOI8sLCNuzyhjMeZ0JnT4OrBeXZdR8Dyo82h0ytF8vg//UqM0TozmwhCs3Doc6SnMuARgu8B5GP3sw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3995f3d5-bf1c-4626-3104-08df1d634ec2
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2026 13:20:47.0204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NccOXM9llaNO9gBB8up9aoNSY0OXb7bi6pbv/Uh5bZdovYZ1ic305ZCCe34n9mtkz05MQMIvj1zMv5ForMWG6bEb+FPhzQpfeOYWep0Uosk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PPF92BFC0A2A
X-Authority-Analysis: v=2.4 cv=T6EZ3PKQ c=1 sm=1 tr=0 ts=6aba69b0 cx=c_pps
 a=o2lqJXFw7WzsGQLwBBQY9A==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=jxMXjlTPpCISP5mWtjnE:22 a=64Cc0HZtAAAA:8
 a=20KFwNOVAAAA:8 a=GZ1BAZDgijZBlYdlHswA:9 a=lqcHg5cX4UMA:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: MvObm6jKBVMBAI3Lo1ta5FMg8nJjutVg
X-Proofpoint-ORIG-GUID: MvObm6jKBVMBAI3Lo1ta5FMg8nJjutVg
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA1MiBTYWx0ZWRfX/rUr5npV0nb4
 k0f+yoI+2I1EjIKH6JTp6mRnJk84COuMsbj3IhSF1HM8JZTzccVZejkhLd0xpvsLf3tw3H7/9ZM
 NRBnuushTI8PIXTZemXBDxxBVfn4v5s=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA1MiBTYWx0ZWRfX2z+4ksQhRqWe
 zhc6SjoL/JW2h2z5oamWYNvB1GbEyT38k89qb3y1Vs8uq4ZSLMa2ngg6awtJi9KNNLA5SYhtXJw
 IydQNHnOiZvfOE5/18uem3YTS6FVDGS7XI86/oENA1RbBmwS8A/gtzeN5Kp8oUHWOZWc08zcB0N
 RPyD9GB/WvaKCs6Ct+JXOWpLb56CkcoVZ61ig1/oZ/xw+s2MJ0uknRPb44JDEDQ/S5rFcqMmZcA
 ImWyoKJUjwWku9t8hLFyHJq9nnW3WmZL8S71OfA5Koo2xW+ajKoXl3hN4tp+5H8VfB68zCOL0z+
 QXNF4CMJxjbsudno+0X3HIeFlFMGkhPPV8RHU/yEHOjLNsn9FFUqXsAH4gl59VMw0uNevxAIGTh
 3SxFzYMKv13i1HEMRRXmFbbLxoK4Q2u74kgGqtBAq6mZ27tMtnqxAV5JWOy/ckOR6wHWXw+b0uE
 goiafdKChKHtReihN+Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjggU2VwIDIwMjYsIGF0IDU6MTnigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gSGkgS2h1c2hpdCwNCj4gDQo+
IE9uIDkvMjgvMjYgMTE6MjggQU0sIEtodXNoaXQgU2hhaCB3cm90ZToNCj4+IA0KPj4+IE9uIDE2
IFNlcCAyMDI2LCBhdCA4OjE14oCvUE0sIEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNv
bT4gd3JvdGU6DQo+Pj4gDQo+Pj4gIS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+Pj4gQ0FVVElPTjogRXh0ZXJuYWwg
RW1haWwNCj4+PiANCj4+PiB8LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSENCj4+PiANCj4+PiBXaGVuIHRoZSBzZXR0ZXIg
aXMgY2FsbGVkLCB0aGUgZmluYWwgdmNwdSBpcyBub3QgY3JlYXRlZCB5ZXQuDQo+Pj4gQXBwbHlp
bmcgdGhlIG92ZXJyaWRlIG9uIHZjcHUuaXNhciBpbml0aWFsaXplZCB3aXRoIHRoZSBtYXggc2Ny
YXRjaA0KPj4+IHZjcHUgd291bGQgbm90IGJlIGNvcnJlY3QgYmVjYXVzZSB0aGUgZmluYWwgdmNw
dSBtYXkgaGF2ZSBzb21lIGZlYXR1cmVzDQo+Pj4gdHVybmVkIG9mZiAoZm9yIGluc3RhbmNlIHZp
cnR1YWxpemF0aW9uKSB3aGlsZSB0aGUgc2NyYXRjaCB2Y3B1DQo+Pj4gZmVhdHVyZXMgaXQuIFNv
IHdlIG5lZWQgdG8gcG9zdHBvbmUgdGhlIGFjdHVhbCBvdmVycmlkZSB1bnRpbCB0aGUNCj4+PiBm
aW5hbCB2Y3B1IGhhcyBiZWVuIGluaXRpYWxpemVkLg0KPj4+IA0KPj4+IEluIHRlcm1zIG9mIGlu
cHV0IHZhbHVlIHZhbGlkYXRpb24gd2hhdCBjYW4gYmUgZG9uZSBub3cgaXMgY2hlY2tpbmcNCj4+
PiBhZ2FpbnN0IGZpZWxkIGxlbmd0aCBhbmQgYXJjaCBlbnVtIHZhbHVlIGlmIGFueS4NCj4+PiAN
Cj4+PiBJZiB0aGlzIHN1Y2NlZWRzLCB0aGUgZmllbGQgdmFsdWUgaXMgYWRkZWQgaW4gdGhlIGhh
c2ggdGFibGUgdG8gYmUNCj4+PiB3cml0dGVuIGxhdGVyIG9uIG9uY2UgdGhlIGZpbmFsIHZjcHUg
aGFzIGJlZW4gY3JlYXRlZA0KPj4+IA0KPj4+IFdpdGggcmVnYXJkcyB0byB0aGUgZ2V0dGVyLCBp
ZiB0aGUgc3lzcmVnIHByb3Agd2FzIHNldCwgd2UgcmV0dXJuIHRoZQ0KPj4+IHNldCB2YWx1ZSwg
b3RoZXJ3aXNlLCB3ZSByZXR1cm4gdGhlIHZhbHVlIGluIGNwdS0+aXNhci5pZHJlZ3NbXS4NCj4+
PiANCj4+IEhpIEVyaWMsDQo+PiANCj4+IFBsZWFzZSBtZW50aW9uIHRoYXQgdGhlIGNwcmVnIG92
ZXJyaWRlIGhhcHBlbnMgaW4gbGF0ZXIgY29tbWl0cy4NCj4gc3VyZQ0KPj4gDQo+PiBTaWduZWQt
b2ZmLWJ5OiBLaHVzaGl0IFNoYWggPGtodXNoaXQuc2hhaEBudXRhbml4LmNvbSA8bWFpbHRvOmto
dXNoaXQuc2hhaEBudXRhbml4LmNvbT4+DQo+IE1heSBJIGFzayB3aHk/DQo+IA0KPiBCZXNpZGVz
IHdlIG5lZWQgdG8gYmUgY2F1dGlvdXMgYWJvdXQgdGhlIGZhY3QgdGhhdCBwZW9wbGUgd2hvIGhh
cyBzaWduZWQNCj4gb2ZmIHRoZSBwYXRjaGVzIGNhbm5vdCByZXZpZXcgdGhlbSAuLi4NCg0KT2ho
IHNvcnJ5LCBJIG1lYW50DQoNClJldmlld2VkLWJ5OiBLaHVzaGl0IFNoYWggPGtodXNoaXQuc2hh
aEBudXRhbml4LmNvbSA8bWFpbHRvOmtodXNoaXQuc2hhaEBudXRhbml4LmNvbT4+DQo+Pj4gU2ln
bmVkLW9mZi1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPg0KPj4+IC0tLQ0K
Pj4+IHRhcmdldC9hcm0vY3B1LmggfCAgMiArKw0KPj4+IHRhcmdldC9hcm0vY3B1LmMgfCAgNSAr
Ky0tDQo+Pj4gdGFyZ2V0L2FybS9rdm0uYyB8IDY1ICsrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKystLQ0KPj4+IDMgZmlsZXMgY2hhbmdlZCwgNjggaW5zZXJ0aW9u
cygrKSwgNCBkZWxldGlvbnMoLSkNCj4+PiANCj4+PiBkaWZmIC0tZ2l0IGEvdGFyZ2V0L2FybS9j
cHUuaCBiL3RhcmdldC9hcm0vY3B1LmgNCj4+PiBpbmRleCBlM2Y5MzFkYmEyLi45YmJkNDJkZDJi
IDEwMDY0NA0KPj4+IC0tLSBhL3RhcmdldC9hcm0vY3B1LmgNCj4+PiArKysgYi90YXJnZXQvYXJt
L2NwdS5oDQo+Pj4gQEAgLTk1Miw2ICs5NTIsOCBAQCBzdHJ1Y3QgQXJjaENQVSB7DQo+Pj4gICAg
dWludDY0X3QgKmNwcmVnX3Ztc3RhdGVfdmFsdWVzOw0KPj4+ICAgIGludDMyX3QgY3ByZWdfdm1z
dGF0ZV9hcnJheV9sZW47DQo+Pj4gDQo+Pj4gKyAgICBHSGFzaFRhYmxlICpzeXNyZWdfcHJvcHM7
DQo+Pj4gKw0KPj4+ICAgIER5bmFtaWNHREJGZWF0dXJlSW5mbyBkeW5fc3lzcmVnX2ZlYXR1cmU7
DQo+Pj4gICAgRHluYW1pY0dEQkZlYXR1cmVJbmZvIGR5bl9zdmVyZWdfZmVhdHVyZTsNCj4+PiAg
ICBEeW5hbWljR0RCRmVhdHVyZUluZm8gZHluX3NtZXJlZ19mZWF0dXJlOw0KPj4+IGRpZmYgLS1n
aXQgYS90YXJnZXQvYXJtL2NwdS5jIGIvdGFyZ2V0L2FybS9jcHUuYw0KPj4+IGluZGV4IDc3YWE3
OGYwMGUuLjkxN2Y3MDljYjQgMTAwNjQ0DQo+Pj4gLS0tIGEvdGFyZ2V0L2FybS9jcHUuYw0KPj4+
ICsrKyBiL3RhcmdldC9hcm0vY3B1LmMNCj4+PiBAQCAtMTIzNiw4ICsxMjM2LDggQEAgc3RhdGlj
IHZvaWQgYXJtX2NwdV9pbml0Zm4oT2JqZWN0ICpvYmopDQo+Pj4gew0KPj4+ICAgIEFSTUNQVSAq
Y3B1ID0gQVJNX0NQVShvYmopOw0KPj4+IA0KPj4+IC0gICAgY3B1LT5jcF9yZWdzID0gZ19oYXNo
X3RhYmxlX25ld19mdWxsKGdfZGlyZWN0X2hhc2gsIGdfZGlyZWN0X2VxdWFsLA0KPj4+IC0gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIE5VTEwsIGdfZnJlZSk7DQo+Pj4g
KyAgICBjcHUtPmNwX3JlZ3MgPSBnX2hhc2hfdGFibGVfbmV3KGdfZGlyZWN0X2hhc2gsIGdfZGly
ZWN0X2VxdWFsKTsNCj4+PiArICAgIGNwdS0+c3lzcmVnX3Byb3BzID0gZ19oYXNoX3RhYmxlX25l
dyhnX2RpcmVjdF9oYXNoLCBnX2RpcmVjdF9lcXVhbCk7DQo+Pj4gDQo+Pj4gICAgUUxJU1RfSU5J
VCgmY3B1LT5wcmVfZWxfY2hhbmdlX2hvb2tzKTsNCj4+PiAgICBRTElTVF9JTklUKCZjcHUtPmVs
X2NoYW5nZV9ob29rcyk7DQo+Pj4gQEAgLTE3MjUsNiArMTcyNSw3IEBAIHN0YXRpYyB2b2lkIGFy
bV9jcHVfZmluYWxpemVmbihPYmplY3QgKm9iaikNCj4+PiAgICBBUk1DUFJlZ01pZ1RvbGVyYW5j
ZSAqdCwgKm47DQo+Pj4gDQo+Pj4gICAgZ19oYXNoX3RhYmxlX2Rlc3Ryb3koY3B1LT5jcF9yZWdz
KTsNCj4+PiArICAgIGdfaGFzaF90YWJsZV9kZXN0cm95KGNwdS0+c3lzcmVnX3Byb3BzKTsNCj4+
PiANCj4+PiAgICBRTElTVF9GT1JFQUNIX1NBRkUoaG9vaywgJmNwdS0+cHJlX2VsX2NoYW5nZV9o
b29rcywgbm9kZSwgbmV4dCkgew0KPj4+ICAgICAgICBRTElTVF9SRU1PVkUoaG9vaywgbm9kZSk7
DQo+Pj4gZGlmZiAtLWdpdCBhL3RhcmdldC9hcm0va3ZtLmMgYi90YXJnZXQvYXJtL2t2bS5jDQo+
Pj4gaW5kZXggMzQxNTQyMjc5ZC4uY2RjMzc3OTMyMSAxMDA2NDQNCj4+PiAtLS0gYS90YXJnZXQv
YXJtL2t2bS5jDQo+Pj4gKysrIGIvdGFyZ2V0L2FybS9rdm0uYw0KPj4+IEBAIC0zNDAsMTggKzM0
MCw3OSBAQCBzdGF0aWMgQVJNNjRTeXNSZWdGaWVsZCAqZ2V0X2ZpZWxkKGludCBpLCBBUk02NFN5
c1JlZyAqcmVnKQ0KPj4+ICAgIHJldHVybiBOVUxMOw0KPj4+IH0NCj4+PiANCj4+PiArI2RlZmlu
ZSBNQUtFX0lEUkVHX0tFWShyZWdfaWR4LCBmaWVsZF9zaGlmdCkgXA0KPj4+ICsgICAgKCgodWlu
dDY0X3QpKHJlZ19pZHgpIDw8IDgpIHwgKCh1aW50NjRfdCkoZmllbGRfc2hpZnQpICYgMHhGRikp
DQo+Pj4gKw0KPj4gTWF5YmUsIElEUkVHX0ZJRUxEX0tFWSgpPw0KPiBZZXMNCj4gDQo+IEVyaWMN
Cj4+IA0KPj4gV2FybSBSZWdhcmRzLA0KPj4gS2h1c2hpdA0KPj4+IHN0YXRpYyB2b2lkIHNldF9z
eXNyZWdfcHJvcChPYmplY3QgKm9iaiwgVmlzaXRvciAqdiwNCj4+PiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBjb25zdCBjaGFyICpuYW1lLCB2b2lkICpvcGFxdWUsDQo+Pj4gICAgICAgICAg
ICAgICAgICAgICAgICAgICAgRXJyb3IgKiplcnJwKQ0KPj4+IHsNCj4+PiAtICAgIGVycm9yX3Nl
dGcoZXJycCwgIiVzIHNldHRlciBub3QgeWV0IGltcGxlbWVudGVkIiwgbmFtZSk7DQo+Pj4gKyAg
ICBBUk02NFN5c1JlZ0ZpZWxkICpmaWVsZCA9IChBUk02NFN5c1JlZ0ZpZWxkICopb3BhcXVlOw0K
Pj4+ICsgICAgQVJNQ1BVICpjcHUgPSBBUk1fQ1BVKG9iaik7DQo+Pj4gKyAgICBpbnQgaW5kZXgg
PSBmaWVsZC0+aW5kZXg7DQo+Pj4gKyAgICBpbnQgbG93ZXIgPSBmaWVsZC0+c2hpZnQ7DQo+Pj4g
KyAgICBpbnQgbGVuZ3RoID0gZmllbGQtPmxlbmd0aDsNCj4+PiArICAgIHVpbnQ2NF90IGtleSwg
dmFsdWU7DQo+Pj4gKw0KPj4+ICsgICAgaWYgKCF2aXNpdF90eXBlX3VpbnQ2NCh2LCBuYW1lLCAm
dmFsdWUsIGVycnApKSB7DQo+Pj4gKyAgICAgICAgcmV0dXJuOw0KPj4+ICsgICAgfQ0KPj4+ICsN
Cj4+PiArICAgIGlmIChsZW5ndGggPCA2NCAmJiB2YWx1ZSA+ICgoMSA8PCBsZW5ndGgpIC0gMSkp
IHsNCj4+PiArICAgICAgICBlcnJvcl9zZXRnKGVycnAsDQo+Pj4gKyAgICAgICAgICAgICAgICAg
ICAiaWRyZWcgJXMgc2V0IHZhbHVlICgweCVseCkgZXhjZWVkcyBsZW5ndGggb2YgZmllbGQgKCVk
KSEiLA0KPj4+ICsgICAgICAgICAgICAgICAgICAgbmFtZSwgdmFsdWUsIGxlbmd0aCk7DQo+Pj4g
KyAgICAgICAgcmV0dXJuOw0KPj4+ICsgICAgfQ0KPj4+ICsNCj4+PiArICAgIGlmIChmaWVsZC0+
YXJjaF92YWxzKSB7DQo+Pj4gKyAgICAgICAgLyogdGhpcyBmaWVsZCBoYXMgc29tZSBlbnVtIHZh
bHVlcyAqLw0KPj4+ICsgICAgICAgIGZvciAoaW50IGkgPSAwOyBpIDwgZmllbGQtPmFyY2hfdmFs
c19jb3VudDsgaSsrKSB7DQo+Pj4gKyAgICAgICAgICAgIGlmICh2YWx1ZSA9PSBmaWVsZC0+YXJj
aF92YWxzW2ldKSB7DQo+Pj4gKyAgICAgICAgICAgICAgICBnb3RvIHZhbGlkOw0KPj4+ICsgICAg
ICAgICAgICB9DQo+Pj4gKyAgICAgICAgfQ0KPj4+ICsgICAgICAgIGVycm9yX3NldGcoZXJycCwN
Cj4+PiArICAgICAgICAgICAgICAgICAgICJpZHJlZyAlcyBzZXQgdmFsdWUgKDB4JWx4KSBkb2Vz
IG5vdCBtYXRjaCBhbnkgIg0KPj4+ICsgICAgICAgICAgICAgICAgICAgImFyY2ggdmFsaWQgZW51
bSB2YWx1ZSIsIG5hbWUsIHZhbHVlKTsNCj4+PiArICAgICAgICByZXR1cm47DQo+Pj4gKyAgICB9
DQo+Pj4gKw0KPj4+ICt2YWxpZDoNCj4+PiArDQo+Pj4gKyAgICBrZXkgPSBNQUtFX0lEUkVHX0tF
WShpbmRleCwgbG93ZXIpOw0KPj4+ICsgICAgZ19oYXNoX3RhYmxlX2luc2VydChjcHUtPnN5c3Jl
Z19wcm9wcywgR1VJTlRfVE9fUE9JTlRFUihrZXkpLA0KPj4+ICsgICAgICAgICAgICAgICAgICAg
ICAgIEdVSU5UX1RPX1BPSU5URVIodmFsdWUpKTsNCj4+PiB9DQo+Pj4gDQo+Pj4gc3RhdGljIHZv
aWQgZ2V0X3N5c3JlZ19wcm9wKE9iamVjdCAqb2JqLCBWaXNpdG9yICp2LA0KPj4+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGNvbnN0IGNoYXIgKm5hbWUsIHZvaWQgKm9wYXF1ZSwNCj4+PiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBFcnJvciAqKmVycnApDQo+Pj4gew0KPj4+IC0gICAg
ZXJyb3Jfc2V0ZyhlcnJwLCAiJXMgZ2V0dGVyIG5vdCB5ZXQgaW1wbGVtZW50ZWQiLCBuYW1lKTsN
Cj4+PiArICAgIEFSTTY0U3lzUmVnRmllbGQgKmZpZWxkID0gKEFSTTY0U3lzUmVnRmllbGQgKilv
cGFxdWU7DQo+Pj4gKyAgICBBUk1DUFUgKmNwdSA9IEFSTV9DUFUob2JqKTsNCj4+PiArICAgIGlu
dCBpbmRleCA9IGZpZWxkLT5pbmRleDsNCj4+PiArICAgIGludCBsb3dlciA9IGZpZWxkLT5zaGlm
dDsNCj4+PiArICAgIGludCBsZW5ndGggPSBmaWVsZC0+bGVuZ3RoOw0KPj4+ICsgICAgZ3BvaW50
ZXIgdmFsdWVfcHRyOw0KPj4+ICsgICAgdWludDY0X3QgdmFsdWU7DQo+Pj4gKyAgICB1aW50NjRf
dCBrZXkgPSBNQUtFX0lEUkVHX0tFWShpbmRleCwgbG93ZXIpOw0KPj4+ICsgICAgZ2Jvb2xlYW4g
ZXhpc3RzOw0KPj4+ICsNCj4+PiArICAgIGV4aXN0cyA9IGdfaGFzaF90YWJsZV9sb29rdXBfZXh0
ZW5kZWQoY3B1LT5zeXNyZWdfcHJvcHMsDQo+Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIEdVSU5UX1RPX1BPSU5URVIoa2V5KSwgTlVMTCwNCj4+PiArICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgJnZhbHVlX3B0cik7DQo+Pj4gKyAg
ICBpZiAoZXhpc3RzKSB7DQo+Pj4gKyAgICAgICAgdmFsdWUgPSBHUE9JTlRFUl9UT19VSU5UKHZh
bHVlX3B0cik7DQo+Pj4gKyAgICB9IGVsc2Ugew0KPj4+ICsgICAgICAgIHVpbnQ2NF90IG1hc2sg
PSBNQUtFXzY0QklUX01BU0sobG93ZXIsIGxlbmd0aCk7DQo+Pj4gKyAgICAgICAgdWludDY0X3Qg
KmlkcmVncyA9IGNwdS0+aXNhci5pZHJlZ3M7DQo+Pj4gKw0KPj4+ICsgICAgICAgIHZhbHVlID0g
KGlkcmVnc1tpbmRleF0gJiBtYXNrKSA+PiBsb3dlcjsNCj4+PiArICAgIH0NCj4+PiArDQo+Pj4g
KyAgICB2aXNpdF90eXBlX3VpbnQ2NCh2LCBuYW1lLCAmdmFsdWUsIGVycnApOw0KPj4+ICsgICAg
dHJhY2VfZ2V0X3N5c3JlZ19wcm9wKG5hbWUsIHZhbHVlKTsNCj4+PiB9DQo+Pj4gDQo+Pj4gLyoN
Cj4+PiAtLSANCj4+PiAyLjUzLjANCg0KDQo=
