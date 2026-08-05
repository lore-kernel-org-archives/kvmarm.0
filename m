Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2953E451B
	for <kvmarm@lists.linux.dev>; Wed,  5 Aug 2026 07:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785915159; cv=fail; b=O9K0wK4D/6NXSANh9lZoiBadceoNLW+3RAAeLgy1aAMkH3kJFxHIBbJ/2kPuhpYeFXUCYv/C20BwY6HjbxG2thDL6RcphsouYZxqrQmZXVn9rEe0owQDFtlwItWzizFEdA6knvMwREDapBltOSLyCYGat3yujSnDoCXA4+qMHoE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785915159; c=relaxed/simple;
	bh=+n2ltES772HBR2us49XYKTuHB3r9moYkSyf29RTyfN4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jbi5XZg1eQfMf8YjhvFYSkZehFc2acT9a1S+ggfdIV6VygPAdgm2uapUYnpbJIWllbM3Y4wAsIGRK72QRdDZVAAramvoHin965faQctYUmQHtbUVLHwum1JHUgLmYjlyaT60WCyA13CM6iYa1ZJawV1DI4j5quv2QYfMrLGYWjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=rugbuI2a; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=PCiCsvAQ; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="rugbuI2a";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="PCiCsvAQ"
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6755oSoF2419033;
	Wed, 5 Aug 2026 00:32:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=+n2ltES772HBR2us49XYKTuHB3r9moYkSyf29RTyf
	N4=; b=rugbuI2aWmK4MsvhcszQmmK1OftY81jrhkUdaHwq6uHDX0fwyYQ0lVy+Q
	GvKujurENp1dZzOzRnNo4pmojVO6gYAOjqwp6KG10UAhF3Y2VVUqHijh7c57HvCJ
	PpJrwLCEIPvPwFdsMQnEWGvllksjLtvmtopOoIi1kNij1Qn2DVbGw7sqSK70m6D0
	VCCe6AWHJSJHNNXz1+JYziajZZWzTQ6Mo5MlHre1VCc0l9NxI0CY0WFszk0pthUj
	PQRIwEbeqIQs+JjaiOScVWnLZzIbgi2z+E5PQ+tdAaiDJEROGffrtq26z8x9CnoJ
	fA8Gh/fvaKcsZKDfzNbu2iDw9+4iw==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11020085.outbound.protection.outlook.com [52.101.56.85])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4fujcjsyjp-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 00:32:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XbrP+12xV555Hs59WaAEr944X47daYx3aq0XomqWDKEOZyu6VkJg2NFSvmh3n9aqykdAyB4/VlHdZcTptEyWsKFCiFWQ1Avx+z//HFYbR5fBUJYqN4lIaNbzBUVtII62ghML8T5+YMGG+sgMBr4MgXRoCwXZaXj9WHf5v9KVJwAQADgub36e+a9n2oMs5UEX5CNEz/RqgzlnKav6RYKj+xuaq5/MckiSOq4QUOiYHmWCaPYiXjNel3+5g99Ija20oVHf5oPIkuPxUDuX4pjGEJM9XpIoFbsmCK5/zVsE72bf+O/aqu0ELfE3EmiKzJ4GqJjpY31a3OjullchQYsrnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+n2ltES772HBR2us49XYKTuHB3r9moYkSyf29RTyfN4=;
 b=iEfbNYt1b2raz7Ph07iYKU/Y3KRsEi/i5MB5giZ//a7F8PkblKnr1DmN4B9S/M1OFdUdNrIoHoqQjsd/9OUHOfDgfn4vdfLFVLxEkp54YOUj/ROEgkDPD0h41bv4fUaEh37RSYCqlx6wmtymo+MbivjJ3ccRIDnQrMRtF0kB4jgzGvFkwQE0HwUGMxNY6YsONwX7x0CBIaCP/Y3m/sxJBBEW2zOcGSRVxGwD2K0o1fpvTWuYRvjSuYtvo7BpQXowXsRq1YzPFgBc7TFiczvUIhGyCqVxvPjT2tMejD6l+kfnZRHZurxJzjQK+JfuEGGyBMYRLux98Bz9bvoJ3l4ShQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+n2ltES772HBR2us49XYKTuHB3r9moYkSyf29RTyfN4=;
 b=PCiCsvAQf5+3p0dBgNkZpnP33LcK8ATPNY9Jz1y8xpIuzHwqtBcQ7j0Qk5RKDF1tzloki+s4kB9QcHt4glha4r1SkNYR1lZHxKLthbbO22q2bjzYjABAYuLe/bYEcb/NQKHQf3P6Viz71KxNa0JZpcHGFsVdbMTyUz2tK8qsrtr4q/GdyXP9RqMSTVhdmswfG/lpxSDMpCYfCgustU6P3G+mSIdeV5qVXGpxHrSwQ4d/HCZ4GzrdT+CUC+dAByj7dX3VXklX2+qhJoXfioSBKthppFRuu68id4g/aeIofmz67UvKDl6dyQYV1E2hmvn5wRZrmbx8/JjMGZydXNgINw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DS0PR02MB9354.namprd02.prod.outlook.com (2603:10b6:8:151::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Wed, 5 Aug
 2026 07:32:10 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0292.013; Wed, 5 Aug 2026
 07:32:10 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Markus Armbruster <armbru@redhat.com>
CC: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com"
	<cohuck@redhat.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "abologna@redhat.com" <abologna@redhat.com>,
        "jdenemar@redhat.com"
	<jdenemar@redhat.com>,
        "gshan@redhat.com" <gshan@redhat.com>,
        "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
        "sebott@redhat.com"
	<sebott@redhat.com>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>,
        Mark Cave-Ayland <mark.caveayland@nutanix.com>,
        Prerna Saxena <prerna.saxena@nutanix.com>
Subject: Re: [RFC PATCH v3 16/19] qmp: add query-cpu-props-info command
Thread-Topic: [RFC PATCH v3 16/19] qmp: add query-cpu-props-info command
Thread-Index:
 AQHdFWubvCZ5bHZqSUmcDdL6/mUClLZ2aouzgBYuboCAAOqvpYAAAIwAgAAGWgCAAAYJPIABkVKAgAAC3zqAAAlggA==
Date: Wed, 5 Aug 2026 07:32:10 +0000
Message-ID: <5F6481F1-B5E1-4B30-A4D1-481D9C0731AC@nutanix.com>
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
 <20260716213858.609699-17-khushit.shah@nutanix.com>
 <87y0f5u78t.fsf@pond.sub.org>
 <6AA3BD42-9596-476B-9F64-AB09372821B9@nutanix.com>
 <87tspa5skn.fsf@pond.sub.org>
 <FD805FA0-9323-450C-9D79-319C0883F05E@nutanix.com>
 <FDD5760F-94E6-46F4-AC62-AB0DC98322FD@nutanix.com>
 <8733wu5qfs.fsf@pond.sub.org>
 <08DA9B28-D5BD-4EC3-8182-FEE212F0C2A0@nutanix.com>
 <871pcd12bf.fsf@pond.sub.org>
In-Reply-To: <871pcd12bf.fsf@pond.sub.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|DS0PR02MB9354:EE_
x-ms-office365-filtering-correlation-id: c4d33420-dc87-4d8a-0b74-08def2c3a91e
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|23010399003|7416014|366016|22082099003|18002099003|56012099006|10067099003|4143699003|38070700021;
x-microsoft-antispam-message-info:
 +PVGxFEEp8r6NBkamWKQpK2bxbD9oXIcRgHR9z/l7zTnnPtLhIDthEjOvydK6toSymU9OpDuJ3aHib39NCpRYKHMnGbutAOjSWXFSCDOYLUxtQNDtJkPM8cWpG05oS8B6CdzQtBiaHhSfyCiJ9lMe1jvrX88TIeopClVvkcxcKIYlMtliPrKedY6//LR8UMdz+vU1Wg8PKUtnIuzqmUZezd7G9D7dACNt+OBFx5cb8BblQgNRUu4APV5y+GMOB/abuwKazm2vc0COsMmgYWIIWWkCSMPpq+SbuwYFPtlmHFjg/Y1TOvLx2IM4a4A3TVSzaETlJz7lCL3lyXlkyPOboFulFrOo41PYLwWVAGTqlrdOgma/RhmTNPhqbeZWZ3wAa5SM6ym24bKtGelSIo3OsL5S26BZ0r3diSOHO7FVVHGdANCIvJ16WwlMZrCJkoAeXti/9uJ2xo9yJeg9ep8K7Hb1b8ltWlwIlwWDnNZKAzyFjEizuTEHvBQxR/jVWrpKF8tADvJS1XMaN4pNlOjH+95Brz7La8ZUT2UlSo8bBTPnAut9QJXdQEmkCzvAume8YhF4WbdPTgqdOEo7swC1c70mLnvcenfHOZwxCZ4sIG7+F6W+kHqxhIsU0/ducO3j52e0BWjD+xJXd1xIcK2GyLP4ndnQ0i+Q3k2xfgRBb8YpKLbr6bobz3gE6OdbtSEeH3rYo3GEhqTqAbDCFti6Hs7moMz+pEL5gxeMmrJneA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(7416014)(366016)(22082099003)(18002099003)(56012099006)(10067099003)(4143699003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bG9uTmpUQUlVMXdyek5Vdi9WSlpqM2F4b1ZpM1ZGZC9wS2ZYSkIzUmtPU0Js?=
 =?utf-8?B?bU5IYzkyd2tSUGxwMzdnWkR5bklGbnkzd05qWWhKQjM4c2owQkVkL0JLSDRU?=
 =?utf-8?B?bCs5cE0za2tLbkR5Tjk4RmhzR2w1NlMxNDh2aXlsSnNwVCs5RGlHeTVqc0dZ?=
 =?utf-8?B?Z25lR1UyYTNXdzcycWpHT0lHKzcrVmxxUVhZcXNXbWtMKzc5VlZrRGR0ZEQ3?=
 =?utf-8?B?d2Vtb2wvZ3hhSDhXWXQxRmxLWUdvTWROTFJMeUxMcGpVYWNOWHErczBZUUFx?=
 =?utf-8?B?M0Jwbm5aaUlMQ0c0TUdGVDhnTTFZbzAvdFl2c25STEdUS0k2ckZaZmVKbHp5?=
 =?utf-8?B?UC85d2NIcmJSNDEvZSttbjZ5QVRMWHJiRmNuWThHenBqKzBIWU5yZ29QdTlW?=
 =?utf-8?B?L3hmbjBvRm5lWkxKMjIzblNFaXB3dUNROFoyQWRZQ2N0WjNJaTRLck5qeG1o?=
 =?utf-8?B?Tm0yVzFlSHJ3YmtYaEhBVTBDa2kzS1RIcU9rU3g4T0VmMkwvcE40V25JSEVG?=
 =?utf-8?B?Y1dKbitqNWp4Nll5NTRqQWJHVzZnaGRFMThCZlUxNDVRcFd6OXlVUEhXNVp4?=
 =?utf-8?B?Q25wQjJyN1BaZ214Wlc0cE5rblNGdU1kK2Qzb2Y3R1VTUDBheEtmeTJnaHgv?=
 =?utf-8?B?Snd5bFVRUEcxcld4RDNKNmkycFFmV0NFNVhEM1EzTVhpWVE0M01wZ2RlQkwr?=
 =?utf-8?B?TnBjMGVHVHVqWEt4cE9ieUU3OUhzQW1zSjRTcDNVdWZ0YUoyRmZTNXpDKzR0?=
 =?utf-8?B?VW1GamtXSjVJckhkOUZMa2lWV1NpREJ5MlBMQXdzRFlLVEw0Y0Mwd2hlSk9m?=
 =?utf-8?B?V1prdGpRTVhkQkdDcDhaSDU3aE51TnRYVFhqMGVId0ZFN090cHVNa2dNZVIz?=
 =?utf-8?B?bGNsOFB5WTZCclErUHArdWN6dEVieUVyNUYvNTRiS085cm5nOG5Nb0wyVzE0?=
 =?utf-8?B?Ly92b3BLSGZITWd0QWxkbEpRZ0ZaMjVZY2EvUWtnelZ4YWVQeFh4Ly9wS3Vl?=
 =?utf-8?B?T2IvZ0g4Y0pJakhRdnBUdU9LMW1SRVdkUUUrTjJISkxOOWs5WldJK3NGMy9D?=
 =?utf-8?B?NnJMYlhOQ04zUXIvWU4wY2hJTjB4SUJHeGsrZTZjV3lTMlkxZHEwNzR4dkNS?=
 =?utf-8?B?bkhVRlR3RWRlT3NVcG1ZUEcwRWgwQ0lvT2tINmtkbmRRRGl2WGhSV1dvRWJp?=
 =?utf-8?B?VjAwZ3dtcjJOOGo0TWRYcUxoM1pKM0dZQnl4WUtkSGNnbkZsdnN1eTRqaU5y?=
 =?utf-8?B?Q3loZlpUR0FKNFF4NkFJMll2cndTYUF5VXdMbEJqUG50ZWR5NFNIV0VGR0wv?=
 =?utf-8?B?c2RCVGNrTjY1RUt6OC8vQnB0eFVSc0poek9td0lxZ0xuelZzZEdZeGE1WWRw?=
 =?utf-8?B?RE85VGxsN2NoUjcrM2lxYXVVd3JYNmtNWVZFRGFCVTI5MUhOYmpwU3VpSllS?=
 =?utf-8?B?QUZUQTdPNGJrSHJRMGFLRDlUMXltRzJ6N091aDdzUDB3MGMrcGhKSGhNM1M1?=
 =?utf-8?B?WlhLSVJqZ2l1RkJyaVFvNjVPQzVSNGphb3J3dndWTEc2YWpEYTBpQVZFTDln?=
 =?utf-8?B?NVR0OU85KzVDY3M1Tjk5ek56SzBFSElkVzNhOUIrMzFYbElLMW0vbHdqdzZt?=
 =?utf-8?B?eFpQNlBSWTlwOEprcXVMOENlRkVtd1RMOGtVK3VOMFRldnF0bXlQT3Y0UnZu?=
 =?utf-8?B?NjgvN1VUT00xQUdvNE9LbUJ6eEZMSjRxcWVnWEhOV1pTeFlyZThLMnljWjBQ?=
 =?utf-8?B?a3p2K2R2REo2NXBNS1NDMDlxLzNtdmM4dHVwUGQ5Y0RxRXBrMmRrelBGWGpp?=
 =?utf-8?B?Y3FPbmRzOC9Bd3Qxa2E2OEFZUUp1SXIzOTI1SUpzYWhaalZMYktoUzgwL2do?=
 =?utf-8?B?elU5TWxOMFJ5VmJVZlBGUGxRMkF0Z29uUXZMSThUVy9sZlBKeEVzMFRObHl3?=
 =?utf-8?B?b3F2a3NlZXA0M1VWSit3UERKVkpyQ1pqNHdtNWRwTVZWU2xTcGxsSGNZUDJk?=
 =?utf-8?B?QTV6c0tIT3JZT0NYQVltVm1XUmMxbnpLbmhYejlXNHpjcHN3dk9vWjNEamh6?=
 =?utf-8?B?SldVRFp1YThlK0hJcERSU0pjRzhyenNRaGRLb3dpeUVka1pSR0NrMFJDbXo2?=
 =?utf-8?B?WDBOVEZaQS8rdGVXY213QjZZdW5TOHcra3VWdFVRTjN4Y0pJZkp4T1EwSk9y?=
 =?utf-8?B?YUtkQjUzSXQwK25lSE04VVJVTC93UlpHaS9SQlg1eGtnMkQwdk03SldZQURt?=
 =?utf-8?B?K3BTd3BUZUQ1L2NQQWs3NkpOVkovSDh2UGFpMWlZdXJqcm4rdk81aDlSR3V6?=
 =?utf-8?B?bjhya1BOQmswaUpGaWFZVS9tNERVQ1VrMGs1em0ycWNETmxKT1ltZ01va3Ji?=
 =?utf-8?Q?/BHZucH5sOFpYFtY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <414B407A84A7B64283908C0F6E99C07F@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	cSa6Ss5Kpo8yiSQXbVCPa/M9BziDWnVCm/N/I7p65M675GTi9RH74MKBOAxD+RnZJVt22XIto1ujTjZDxT32ubGETl1927zIitGPXi3k1lljlEWIvEvJRXFGgDlHwJ1nQ9Gd5cY4lDcSpJvNkcNEYKIUR8fav5J55zr4sHb8+wNXmgIUSxGrb+Ycm3twoA2mAvhPUdmJOpM6+pMfvseYzUgP6AeK7MKpwzecNkq78vDIAy6ha/AYpuC3gqkxG8zCI5JsQ2Dm6t+tk/ADBGjZf+O4CqOIn1TmvVmYVdKV4u1ATUUEG6IIIwcuC1NJs3zOEJEmF2FBlqFNQZlaUQ7VNg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4d33420-dc87-4d8a-0b74-08def2c3a91e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2026 07:32:10.2567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t9PndZSFVND8LU9BKmp5oYtprR6oaMe6N2f/Uw9jSwbVVfbbm8pvqTQwD/79N7GelCzhwDaB/DMse3g9P7d3r368OT3lwZk25pWFVRpLfPA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB9354
X-Proofpoint-GUID: M2jfTJrYS4NSG_D_6hYt1OF9uvSzfEmL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA1NyBTYWx0ZWRfX47p8ByxpYHPg
 rPB6qh8iZmBq65dyMEr/wg4qux76rBqRbGYc/Sy6YeLt0r2D5UCApvzUPUK3SHE7zuCGEu2dIYg
 Aiq3k4g32vl7OQYpAEphGHjaIbiplBYnO5ErPLE61BsLOJ1L5ql4/86/FbhUH/Lv6qm8HORtdJs
 /KjeNDwWZ7zF7/GLbn546dtMfUvdlRLx4Gce/OG41oYbiq2ZekJrBklgdWQ2oJtx1IGyN7Ud0xz
 8+7ERa5Ng6ihg45sZ2abQNEtxTBS7zPM5HFcym+XDBTe77NYbalD09/K2plO8V8lU5a5r92sAQ7
 Pn4nMuYuoxe6IBUkARWdYyLKNa+iv+oCnDzgz2YLxRrJm3fUJp4Ls7JY+j3Z0kP1YdJaGB1n6QI
 FZ5tPZH/XkpPMTR2Je0/6Wsp4Fe7J2u9AbteWm5yxRiWgOK3BEf1EpnUZAonRhxv9JNhrYLYM5N
 SjAS8TPokoObIljWxVw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA1NyBTYWx0ZWRfXxPGB/lP5+WTk
 myb1qmfG6A6Cthw0gg124j8qiZP/P0Qv4oqEj3EQlkzPmHBPAMVDEu7sdcCGblNWD3X/MajQ9q/
 Y0VASzskA7S+sv6UfY40i+ASnE3LkTo=
X-Authority-Analysis: v=2.4 cv=VOHtWdPX c=1 sm=1 tr=0 ts=6a72e6fc cx=c_pps
 a=82Hej2R/WPb/df+cPJtM0A==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=_-M8LpHI31CeLmyZm6wg:22 a=NEAV23lmAAAA:8
 a=20KFwNOVAAAA:8 a=64Cc0HZtAAAA:8 a=QRvg02EUTXLpWuX6-e4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: M2jfTJrYS4NSG_D_6hYt1OF9uvSzfEmL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_02,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gNSBBdWcgMjAyNiwgYXQgMTI6MjjigK9QTSwgTWFya3VzIEFybWJydXN0ZXIgPGFy
bWJydUByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjog
RXh0ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gS2h1c2hpdCBTaGFoIDxr
aHVzaGl0LnNoYWhAbnV0YW5peC5jb20+IHdyaXRlczoNCj4gDQo+Pj4gT24gNCBBdWcgMjAyNiwg
YXQgMTI6MjHigK9QTSwgTWFya3VzIEFybWJydXN0ZXIgPGFybWJydUByZWRoYXQuY29tPiB3cm90
ZToNCj4+PiANCj4+PiAhLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLXwNCj4+PiBDQVVUSU9OOiBFeHRlcm5hbCBFbWFpbA0K
Pj4+IA0KPj4+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPj4+IA0KPj4+IEtodXNoaXQgU2hhaCA8a2h1c2hpdC5z
aGFoQG51dGFuaXguY29tPiB3cml0ZXM6DQo+Pj4gDQo+Pj4gWy4uLl0NCj4+PiANCj4+Pj4gU3R1
YiBmaWxlIHdhcyBtaXNzaW5nIG9uIGFybSB1c2VyIGJ1aWxkcy4gDQo+Pj4+IA0KPj4+PiBJIGhh
dmUgZml4ZWQgdGhpcyBvbiB0aGUgcHJpdmF0ZSBicmFuY2ggaWYgeW91IHdhbnQgdG8gdGFrZSBh
IGxvb2suDQo+Pj4gDQo+Pj4gSSdtIHdpbGxpbmcgdG8gcHVsbCBhbiB1cGRhdGUgdG8gdjMsIGFz
c3VtaW5nIGl0J3MgYSBzbWFsbCBmaXguDQo+PiANCj4+IEl0IGlzIGEgc21hbGwgZml4IDopDQo+
IA0KPiBQbGVhc2UgdGVsbCBtZSB3aGF0IHRvIHB1bGwuICBXaGVuIHlvdSdyZSByZWFkeSwgb2Yg
Y291cnNlLg0KDQpJdOKAmXMgb24gdGhlIHNhbWUgcHJpdmF0ZSBicmFuY2g6IGh0dHBzOi8vZ2l0
aHViLmNvbS9raHVzaGl0LXNoYWgtbngvcWVtdS90cmVlL3Vwc3RyZWFtLXJmYy12My1maXh1cHMN
Cg0K
