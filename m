Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2088.outbound.protection.outlook.com [40.107.243.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B98138DE1
	for <kvmarm@lists.linux.dev>; Mon, 21 Apr 2025 16:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745251442; cv=fail; b=hmC+gJuoDVeuZJt3npkyxSPwK5NPzYdIPE8KvUiRBZ0R/PfDavgeEIIIXK4hAckkU4At2A4W5qD1ynfeNBoXEe/+7fNj6YHKyR7h/wIx5NWaXlMwA6AJvr5SbbjLL7jTID5kMiutwDjgfZ1o2U4QTHw9CKuHMHQ9l2DGYUf2Skc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745251442; c=relaxed/simple;
	bh=dstAmzE3wJ5S7ij8nmFqka3D0Sk4tLfsqblYmIOVGmE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mY4ihxDTxAlq4RQ2ybiD3wpcQj7fz6bIAOYG2fJLK9jZQVlfwic4bG7LbJYOJkxdYqQDgt+b/RhzJlcVPBDDSDeONDlcdmb9J5ujE1vPvG+oojGgmFivNJVf429neumi82QJhBGLYPxGm8I/fYULFL2/3rHY70w0ODkf/vhI/ts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tjwGuzPF; arc=fail smtp.client-ip=40.107.243.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tjwGuzPF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ltstESWrI/s3Uqo+zvpVMyNbwD0Kg9tFqNwnF8piooX/o3rH3zy0YwMzoPOPGmikguDk//xoUD/R8J+6X0lBr1ScqgPKAKe4aQ6ohHVCSweuUHNapZRP420BuH2l6NyaCmJvYFeY6i9y7d68flZYptxMWyenpS+XBl4a58Y6WkCfPyIWrxUxdvbHRuNeie/XQhOn4XqIDHbVRy8yDPENZbhsQmFImI19OV+e9HIe7adqtlc1u4SMkajcCfTPTXajdr8oXKSgFPGkCubAx8vqd4tW2B+cxDRrAwmgRldSRtuKGPK1VAKbv0ZH8XYKQU2fcNnUaiq8bbDXTVi5YS45/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dstAmzE3wJ5S7ij8nmFqka3D0Sk4tLfsqblYmIOVGmE=;
 b=N4gHYiCI0cfs+S0erX85WCI+9fW2ZfF7A0kud3RJoIGHo1vi+FCW/UsaMjyy5At+CHOlH8ohRc1iMB2d1C5PslwTB+H9mHEAOg1/btzNLtaUIWYSPq1hrexCkiDOxhU8UnUvxyTXxyay/qFkjlGdoEYKvRiKCqpxmCTKVlCpgIgU0n7XVSUMbkDH1bFzDNeZ6F1/V1ND2SiG82iSf3VqDLwiOqgABiCZjvdW07bmuu4qdoxkIwNkAKO2w3JwsalSl/BXQNFIEclW86RkTAcdqveaKXkTyES+PZGXiJBFfS9lgvvdaWBJanZvNfOo1qjk5C1nIiJhgdKrOSNgkKbLMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dstAmzE3wJ5S7ij8nmFqka3D0Sk4tLfsqblYmIOVGmE=;
 b=tjwGuzPFP6yeGGpYkCTr17OPr1zO403ptQn2p/H7AV5uVVrdHI386G5DtQIZ099Rw20t/YVtTHvA6bz5XklxzZOf4Oz+AU6jwXqIitlvdu151h86Z4rQHao99v+KB5N1PR71lNkT3xXgZBsxaO+UuwRfi7dhtzqnZrrRlkcWIVk+729yC+eJu2YUAXtc7s0MJHDX5c59smPT2tvAH7aKd8rqYyKqf5K2nPRxhA3tpMVxDab9mvNjgVeXRDo67DYIabM01A5dKDI3j/VNOJ57Ve9LNGOrIPGN6WA1q+gOGF3WyGpxfAfTPhQknYJx/chnhidfO9xaKp6NSJ+W8Za/rw==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by PH7PR12MB5686.namprd12.prod.outlook.com (2603:10b6:510:13d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.34; Mon, 21 Apr
 2025 16:03:55 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%7]) with mapi id 15.20.8655.033; Mon, 21 Apr 2025
 16:03:54 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Sean Christopherson <seanjc@google.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>, "joey.gouly@arm.com"
	<joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "will@kernel.org"
	<will@kernel.org>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, "david@redhat.com" <david@redhat.com>, Aniket Agashe
	<aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram
 Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams
	<danw@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke <udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	Krishnakant Jaju <kjaju@nvidia.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "sebastianene@google.com"
	<sebastianene@google.com>, "coltonlewis@google.com" <coltonlewis@google.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "yi.l.liu@intel.com"
	<yi.l.liu@intel.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "gshan@redhat.com"
	<gshan@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"ddutile@redhat.com" <ddutile@redhat.com>, "tabba@google.com"
	<tabba@google.com>, "qperret@google.com" <qperret@google.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Thread-Topic: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Thread-Index:
 AQHbkaduhEbbxySPq0WwO4LU4q6wXLNsQygAgAD/GeCAAIkeAIAAC14ggAFVjACAATjx0YAGtS0AgACvDoCAAOaHAIAANr+AgABucICAAD0IgIAAg/iAgACoeYCAABKYAIAAFAsAgAAouYCACiALVIAAbFcAgAANkACAAAgBgIAAHy6AgAAGMwCAB6GYgIALBt6AgAAPgwCAAAfeAIANn5WYgAhUlXQ=
Date: Mon, 21 Apr 2025 16:03:54 +0000
Message-ID:
 <SA1PR12MB71991540C9CF5ABCECD08212B0B82@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <Z9s7r2JocpoM_t-m@arm.com>
 <SA1PR12MB7199C7BD48EB39F536DD34DBB0A62@SA1PR12MB7199.namprd12.prod.outlook.com>
 <Z-QU7qJOf8sEA5R8@google.com> <86y0wrlrxt.wl-maz@kernel.org>
 <Z-QnBcE1TKPChQay@google.com> <86wmcbllg2.wl-maz@kernel.org>
 <Z-RGYO3QVj5JNjRB@google.com> <20250331145643.GF10839@nvidia.com>
 <Z_PtKWnMPzwPb4sp@google.com> <20250407161540.GG1557073@nvidia.com>
 <Z_QAxiEWEyMpfLgL@google.com>
 <SA1PR12MB719976799AD7F9FC4407A5A9B0BD2@SA1PR12MB7199.namprd12.prod.outlook.com>
In-Reply-To:
 <SA1PR12MB719976799AD7F9FC4407A5A9B0BD2@SA1PR12MB7199.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|PH7PR12MB5686:EE_
x-ms-office365-filtering-correlation-id: 8b241cce-906c-452b-93be-08dd80ee1dad
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?KucMiuuBXw/O50VG2IlxHe/3iU+CgRFr0JV2EZzfU5u4jz8fDj/ZTegHXc?=
 =?iso-8859-1?Q?hRyKw5kbLHIbagQrjVFeh9fihq34oWx9NCdARz8KQlEKzInYphA8tSEGqO?=
 =?iso-8859-1?Q?XNGkGFg3Rm0bEot2vHtzOZz0EC4K1Y1r5UU/RqJ3D+WH283SZoVHc0L0Lx?=
 =?iso-8859-1?Q?Tv4VjEwKYsiuGZL7cs0wJD+n7JFUUv3vIOCRlGW2JDpWldw0iZWkLTE07w?=
 =?iso-8859-1?Q?WfnOy4xTnu6WCPPNEwJ7pvro9Z5tzTu3hzQMlpgZAnPyiXgVV7UXL/Ycym?=
 =?iso-8859-1?Q?IKbNw+8kk6kJp6YxXAPMZd/FM13GiFgv8Sgqs6tqlUFGCbk9wFWV/17Dwy?=
 =?iso-8859-1?Q?ZkZk5l6/OLDMUJCgzJ/BMtpicqsbNP7jh53PUBuuFk/7t+UECdhwT1ZpAH?=
 =?iso-8859-1?Q?TCoLDJFTFs/6MGN1Ao19KPrdv7zR1I0HqbOXSlp+lba/xjEmlKd8IZAgBm?=
 =?iso-8859-1?Q?K7bSfVm3lHBcesprJpcYtaKxjQ0dIj5WND2Cz6xx3BLgUpXiHealB8U9OF?=
 =?iso-8859-1?Q?RGmPnQraUCEsvDbtDF1gziuFIpzLCT/s2VQZfUaRQ7OkdvKVInBTinrDHV?=
 =?iso-8859-1?Q?aFLQ3zFlmRlhm2FI78STzBWCsyOCMPNpJs/NywjMiSKfSDvJ0WoZkUybe8?=
 =?iso-8859-1?Q?1c36VLyradxtgZ2G6w7hZtiq9EnxVPtxlcD9y3FOxWA8mJDxAp4HC5jDnw?=
 =?iso-8859-1?Q?nthwqDGKaPHykVxxE/u1jR6Sx/xfv4U9Vcb7wbUJfnmr6KMjJ1egU9CoF4?=
 =?iso-8859-1?Q?eoZBpIBaGv8hG07aFw0d2QQ68W6hsu5aRsimVMRagprxfFsF16WKVUj6mu?=
 =?iso-8859-1?Q?3t9AR7Ohcdsv7i3e1pxwzNY7a3w5Zr5g2BKxq6a9PPcW3H8gvWYiHLwusV?=
 =?iso-8859-1?Q?qgfvo5uL9EG2EACqyr+k+zYQ/ECZ82dTB2dgVksODtXdawBZmXgovdVdAj?=
 =?iso-8859-1?Q?DJaldWetBv7u4yXdeyc2jgMw61GYEGeyENfh/XG0435ogOz46vpkBlIFwy?=
 =?iso-8859-1?Q?a5yeG13qM/5f+Qlnrmx4fzc3cad5xmXnNLaYhzdZ/jRzD26kgD/HnPw5s2?=
 =?iso-8859-1?Q?tzgM5WgnOtndeeXgwBmoFTBDWdvD8OoVelXZctOwNnEGSJMrNVq1V7C5mM?=
 =?iso-8859-1?Q?LlW9LM2QQXA9vmC7P/V8RFzseN+rk+79JitnnBmqsn5Mi8CJITmC73GpOC?=
 =?iso-8859-1?Q?EDYMlaKMsRgKsm+SqBkXoERpLt8F2BTOlCHWMxc2D+Kjq2htz3EUmebNx9?=
 =?iso-8859-1?Q?jGohuAoo3qPCtGFwE3WFcR7c1tG50cREPXJ+pAcYJhl+e2OCWiVGOLD+/z?=
 =?iso-8859-1?Q?H1b36zmQy78q6K5VGxxarexMJRze93xC+Tg8FWDOUdC7QL73GiSM9ljMWm?=
 =?iso-8859-1?Q?0HtQxojMRK/uXzsZOdCGGX+v6XWCJH/FNXRH+1lIqvoXJZsoq/YNJqyjc6?=
 =?iso-8859-1?Q?OFZ6IM/4Df9Cyu/CS+3atJv93hfM+ZojezCBDbzSxs78wn55INiqcEExIE?=
 =?iso-8859-1?Q?gv97EpPTVtEtf/jJyJPkckHL53V4ypqfrRQ5vqishrrg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?oYhdRqtYy2ttO4vPLLAitzNMY59u2dUeFlomGCbT8Z5AyykCIL6pIrqKqL?=
 =?iso-8859-1?Q?KuPKYUmYvfJfBYeIIVIPnnStzSslcAYiu089YxO3AEUJF7qYdlJdNWFl6Q?=
 =?iso-8859-1?Q?g80HePVt4sKkmliTRabmlaBRsyHyogvViYuNn+aU65BDowOvxHYhXH2I/j?=
 =?iso-8859-1?Q?v4YaG4kBJudwrQkK0LfE7p7auUe1+lYD21pL1QAooZ71msypMu5LNJR9AC?=
 =?iso-8859-1?Q?KBdfZWX95hqR3mgvllp3G8xE2yH2u+29IZU5kraDzfXhB/fxeOdcYdzk6V?=
 =?iso-8859-1?Q?tRVCKhImH2vmWh13gTJUtZe5/EtuohOc0b6Zgv/p3mlUM3UgMMlkxEVZWk?=
 =?iso-8859-1?Q?SNNLR6NYV7CrBMb6HWUqG9WqmPHpPePzhjZgxL2XHr6dWZVaxajm9iEhGv?=
 =?iso-8859-1?Q?RngSHHmpEm1kVQ9wTHTm9pG3eP9edsf0+ycmhiQMbDdcxSRVt1jVKvIVgS?=
 =?iso-8859-1?Q?VWijnZBDXLUQ8EeS58d+fQJUWVj+y/Ho9CyEvB0siy+QiXCSDNk0K7ecRu?=
 =?iso-8859-1?Q?H+sdN7vAR5Sz8qTNfFJ+3GQDb2aHGw7pMrQ77ZkA8nQDYaEKKCScaVk6f4?=
 =?iso-8859-1?Q?MLn6QeL61BnttICfYEkXMVatoYChIjJisgyJTw81rm9nIvUVZAdEgSveta?=
 =?iso-8859-1?Q?3EXVCsf1JEm3HbxNQXXXpVPRYmlbgjTpIzrXrnAUBchHIliLpwvTLJPUv4?=
 =?iso-8859-1?Q?gUzJw7XSfvgU/ACSqIg3l7JOoEQPT1srW5Ov+75huw2OiyA7BvLPlJ+OlT?=
 =?iso-8859-1?Q?/2KrSIAjh9GnjLDQKKrBMA15CV+KdFYBqnNI4+LsLqiv4bnMFjNYNmbHs6?=
 =?iso-8859-1?Q?als0vFhtbOb1udQ5eADOV941nRrZL2jE1IMS5XxqLunldkSl1DP9Wxh//y?=
 =?iso-8859-1?Q?cwfsLbTXB6GRWL1IAyhLdIhhiKRrbdPhu0t22SCWwC4Cdao0D0qN7Y6R0d?=
 =?iso-8859-1?Q?t2BA/jkl/JtF0nuQgLFUE3KXi3xyqqYt9Nr24uIoWmb0oVRTfzmxHfFLxh?=
 =?iso-8859-1?Q?bJObg6EAuvD9btvMQVFYsA+kKGphTQBjOAH9ULmF787I70jqLHvnXBSHT4?=
 =?iso-8859-1?Q?wXISupH3XAmMIO7CZYfosCeL6YFDLRSbtQATkE9ak5fFd5VDrL75Hu6KXs?=
 =?iso-8859-1?Q?UEEnkKMY1Y87b8ZVNjv9mV/zzvhg4F13C/JfSSXmBOk4ZzKHXuD9KWddrI?=
 =?iso-8859-1?Q?Ok4VH2+LvAEedUt90M/dEZG0tGc+TFs7ZyhB2QpiO6FcIdP5ZsX3nmHa5K?=
 =?iso-8859-1?Q?kcAsP8PctKoSRjIwFiGr00fiEN6VgTFPUjsUlX3vd2IMO9Wzj+tLs50+uc?=
 =?iso-8859-1?Q?KTi8ZjDaF86OCNCh1ZAKIpGh4RaxnafkqhFpyJVl3gYKaipMYNhH/fT5jf?=
 =?iso-8859-1?Q?kwv/vNyWY5xYBNJlhhOB4toNye+1d8HRb9YPP8JDOFhGjTVnlvTjCg3udh?=
 =?iso-8859-1?Q?oLZJ2o2gUR7cNhCV585SCF7QoXFjE8PDU/zTaS2vBVUphhmNlLsOJcZu8h?=
 =?iso-8859-1?Q?PS2wc2MuteRgC2GWvCYDz4J+WGmuSYgsiYxGFIlvULO3XM6bt/tTUAeC6K?=
 =?iso-8859-1?Q?YA1IwelC3UM/xq/A33s0qToNlJWMsW0lzW+pJWY7DpvDjWAX/GUFPM1/D1?=
 =?iso-8859-1?Q?Ug8mHD1CPdbww=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b241cce-906c-452b-93be-08dd80ee1dad
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2025 16:03:54.4462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lC1+I7AiYryS8CUOGEvDFlu8KCQxLkpOZqg3nkRm0DNnLKZ961Hiyd0mDoRAFxn00g3cdB0f5irW2R2EqX5GXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5686

> Hi, summarizing the discussion so far and outlining the next steps. The k=
ey points=0A=
> are as follows:=0A=
>=0A=
> 1. KVM cap to expose whether the kernel supports mapping cacheable PFNMAP=
:=0A=
> If the host doesn't have FWB, then the capability doesn't exist. Jason, O=
liver, Caitlin=0A=
> and Sean points that this may not be required as userspace do not have=0A=
> much choice anyways. KVM has to follow the PTEs and userspace cannot ask=
=0A=
> for something different. However, Marc points that enumerating FWB suppor=
t=0A=
> would allow userspace to discover the support and prevent live-migration=
=0A=
> across FWB and non-FWB hosts. Jason suggested that this may still be fine=
 as=0A=
> we have already built in VFIO side protection where a live migration can =
be=0A=
> attempted and then fail because of late-detected HW incompatibilities.=0A=
>=0A=
> 2. New memslot flag that VMM passes at memslot registration:=0A=
> Discussion point that this is not necessary and KVM should just follow th=
e=0A=
> VMA pgprot.=0A=
>=0A=
> 3. Fallback path handling for PFNMAP when the FWB is not set:=0A=
> Discussion points that there shouldn't be any fallback path and the memsl=
ot=0A=
> should just fail. i.e. KVM should not allow degrading cachable to non-cac=
hable=0A=
> when it can't do flushing. This is to prevent the potential security issu=
e=0A=
> pointed by Jason (S1 cacheable, S2 noncacheable).=0A=
>=0A=
> So AIU, the next step is to send out the updated series with the followin=
g patches:=0A=
> 1. Block cacheable PFN map in memslot creation (kvm_arch_prepare_memory_r=
egion)=0A=
> and during fault handling (user_mem_abort()).=0A=
>=0A=
> 2. Enable support for cacheable PFN maps if S2FWB is enabled by following=
=0A=
> the vma pgprot (this patch).=0A=
>=0A=
> 3. Add and expose the new KVM cap to expose cacheable PFNMAP (set to fals=
e=0A=
> for !FWB), pending maintainers' feedback on the necessity of this capabil=
ity.=0A=
=0A=
Hi, just a humble reminder to take a look at the summary and next steps.=0A=
=0A=
Marc, will you be able to confirm if you still think we should have the=0A=
"cacheable PFNMAP" KVM cap?=0A=
=0A=
If yes, I'll send out the series inclusive of that.=0A=
=0A=
> Please let me know if there are any inaccuracies.=0A=
>=0A=
> Thanks=0A=
> Ankit Agrawal=0A=
