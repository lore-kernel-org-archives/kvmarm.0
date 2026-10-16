Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA493BF66B
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 06:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792133452; cv=fail; b=fn+iy9gHpnoOX7kcx6JIJ8m/U6Yy1rRJLVgqzt/ML7llOxXgZlWO/8LfMEdR2TSTBmYZjRdslVv8LQcFNCIXN4jJG0Y4xYh4aWwKqUH8t9eSxc4O43i6kyBQFP6gOn27shNrGbMba5fmD6FyHA65yo4TI1iq5RnvALqrWtZ8YN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792133452; c=relaxed/simple;
	bh=BQP/6n4KjG/NfqRB9EClGOC54anjJhxN5ft9BIgY//Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DxWtPIM49xwSvVxk4lEhE2ZrRMRCP9BoKXVBprYmDNNXMHxkfDZn1YV4DDncZ/rBVYCi3DFfPd33XyXJPckBfEu4ZoCLRf1GYRmAiEmC4phq1uJR+j4SLyTpXNi9VmZ5V4mxDMX0Ghl5yzWsja/weNrgrSB3eebYv+Yxe+k5pe8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=FlwbKNHH; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ZJEZoy8n; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="FlwbKNHH";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ZJEZoy8n"
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FKUAhO4081735;
	Thu, 15 Oct 2026 23:50:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=BQP/6n4KjG/NfqRB9EClGOC54anjJhxN5ft9BIgY/
	/Q=; b=FlwbKNHHB5q2IGAo18a2CwwxxtqVDVdugn1X0ZUsBsc6sZDLSG2xsstGq
	bdHiDUJhuxDv5mAH53qZnjMcW29tXYYnT7ZLHSqeA9rhi/746CwfHKURsro9A+Oq
	9e7qGuj0+2xmL/zPe3CE2mR2Wty3/++AWnqvNq0YMAFHDZzs0cM80Lm9/tk0dfzy
	BhjXlhWRPh8cuV08RYE4qwqLKVjDPSablUikA3GVRIwv3SmY3QSAO45WmWiIYLvZ
	y68iRHN2Vqe3bnsZI4XvZS5aDIzHr0JzJlD85EkJiciMa6q52s3HdNAWvdtJWb1Q
	MmDEpZBucFpp2l4FnYB4mwdsOaa1A==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11020104.outbound.protection.outlook.com [52.101.56.104])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4haxj929xe-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 15 Oct 2026 23:50:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ng/mHbSNYkoSWvbqiALhilCVPgp943FplemIaRQ7Olx6FtN8Wn/+sg+WWBzZXuOgXjhBtk17lCjHC7ADs7rOvH4msSBDD+7lIKhkvYzX8L6Bo7p2Pdzx6JxVzuNrC39uvz5hu0wSejrx3j7IO3yRxH5aaK4zkRZbcw9aMVtDSOJvFADmUqTQmOaQL23hTUr7VTa0PSJ4tL4c8nrJOlfBTHk17zj5Yx9ZLaeWdEFJqWZ9Fno8KXQzrWN9RevSKKrTtykyaNcN8AoQA3bxBwkNzyFIA/k499szoEksZ9aGm7jqAtM0JpSggq3B3WMZW+HkAIivmayJooItfWpGGec/Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BQP/6n4KjG/NfqRB9EClGOC54anjJhxN5ft9BIgY//Q=;
 b=ACYSXQVkiGv7sg5VnwW+V+tKmT1KBynIBSvYOj0peKicXOkCE/BFRvLTy0v7Fc7+tI53mjrSHxVTwIYYRFXDc/Mmji38Ya99LgIu6NjJDF4JUBxlzeTSXImv81iYxyYq2Fc2DzZx4LgXM6BD8kNecbNjnTOqrBp/SQeE9BNsWoZpum4YpZmV2OnbcBs1PzUD4X5Avnbu+bp4AvLKBRWaYtTBXO8XnpNKrfmQ8X7km3dMBV4v2DB5Ou7X8s/4u8ixzpxJZeABYMIWJQgxy7cMQq0SMz+6FslRBZREffdUpczankhij6tJTEBXF3Xw5ip6hhabtoqaPrtjMxWorwVlUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQP/6n4KjG/NfqRB9EClGOC54anjJhxN5ft9BIgY//Q=;
 b=ZJEZoy8nFRXhPwVvKr+czz595EZSr5VnWnlpwj0od0QYKXWTvTqbgEfifO3SHyZ6CtTKkEW3HR9sAKFgH0XAFYr9lB98xn7zd8MjQijyLd0CrAa13d8u04mmDfcuDJ712aROidlv+2bA+YLitv3r9LRe49s3PHWJ7Dewuh49Ox1vC81uGC+jlPEWCXZ4N9h2XdauqiNvvuLy8kX7ExWJpDG78AFefyxx3Ytm2sg1S1Z/rddyssNM7INx+AmwAQJ+a7Q6T3IhCBKbjhy1/yEjpfx7KHP+9DI0ijWFJsPCRa48BkB0mKWvNkmvf4OeE9rePxiuYudINWMunTc7DyyIIQ==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by PH8PR02MB11928.namprd02.prod.outlook.com (2603:10b6:510:40a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Fri, 16 Oct
 2026 06:48:07 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 06:48:06 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: "eric.auger@redhat.com" <eric.auger@redhat.com>
CC: Peter Maydell <peter.maydell@linaro.org>,
        "qemu-devel@nongnu.org"
	<qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "cohuck@redhat.com"
	<cohuck@redhat.com>,
        "richard.henderson@linaro.org"
	<richard.henderson@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "berrange@redhat.com"
	<berrange@redhat.com>,
        "abologna@redhat.com" <abologna@redhat.com>,
        "jdenemar@redhat.com" <jdenemar@redhat.com>,
        "gshan@redhat.com"
	<gshan@redhat.com>,
        "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
        "sebott@redhat.com" <sebott@redhat.com>,
        "armbru@redhat.com"
	<armbru@redhat.com>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>,
        Mark Cave-Ayland <mark.caveayland@nutanix.com>,
        "ping@khushitshah.com" <ping@khushitshah.com>,
        Sandesh Patel
	<sandesh.patel@nutanix.com>
Subject: Re: [RFC PATCH v4 14/25] target/arm: add neoverse-v2-v2 named CPU
 model
Thread-Topic: [RFC PATCH v4 14/25] target/arm: add neoverse-v2-v2 named CPU
 model
Thread-Index: AQHdScVqjCKnYjJuMUuIeI2Bc+PBfrb+qYeAgAACjoCAABzrgIABGACA
Date: Fri, 16 Oct 2026 06:48:06 +0000
Message-ID: <0F5C73CF-185D-405B-BF81-2FF065C1CAD7@nutanix.com>
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <20260921123249.1708067-15-khushit.shah@nutanix.com>
 <395b66c9-4173-401b-b469-8972b710aae2@redhat.com>
 <CAFEAcA8DcLLYJeE_NUKrFTKfYvHp+6YYAmCdZnBfz2AjRNDnzw@mail.gmail.com>
 <a1245318-1843-45c8-9822-bea483a3e660@redhat.com>
In-Reply-To: <a1245318-1843-45c8-9822-bea483a3e660@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|PH8PR02MB11928:EE_
x-ms-office365-filtering-correlation-id: 02461b82-e1e5-406e-ecf0-08df2b516f4a
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|7416014|1800799024|23010399003|4143699003|38070700021|56012099006|18002099003|22082099003|10067099003|261009223027099003;
x-microsoft-antispam-message-info:
 UTN2MuEPbnI/s2ug9By0LWHjzn0akp5GmS3mkHXILSMzuCw2PIz+95exh9sm8EoCdMcrJyGDkEJZkb77+BS6rmynuefP1k2OyvLNEYwo4SGuRaffSxrc4pqe5TyaMJ3WLnQvoO8DXjKYcRdPl79Ue9+e8frxwCv/jUk+hMpSWukPb9Bgs0UQEZy98d6/cFGbUyxt2dOtZPXsQ4dqC+u9W1XEoLY1eoMqKYPXbB0ymjZMUJTUvGrPcGNVyFLeiGdCqHxAhIBPz67/V4MZg05u9bLCLH84ElqKfmYPcOIlOijYCYc4EIycrvcGXvG2m1RfOCxkzubtkAMFrqeUz5Ec4dGs3l81a+5eAa2Dkco0ATb9g3ZdMH6Hdp+cP2UtwkYDERxnU7k53REiwUXNtcF7jHLjZCR63z5UnfwgLZXBZdQ5pFLb0gjZjEfVX1RyylgOj2vM3dMTjQv72yKywI23Qmqj6/cG9zE/rDcERijg+ldoDJXa/HfqqOmqUZoAqJiTXw+aw6mCXMcJq2sPIYuwZchuqv/Z7ieRxPW5nNetFrgenjUDvsdgacynrae3xRJ/dXc+o2wYlwiIoaSP0IQarEjJtLqERLs6gHFvqYmb8z4KfKAl/OVcGOFClTdSOCE5MLkF0BOcFaXqII9LUMxS2q4eqniNmU+bn85u06PEoC4wYmjjLOZNkAiPenk8uJ87ioSHJNPR22G3LmUL2Fdiml1r/KtdRTtBwzfoIDQyIEM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(23010399003)(4143699003)(38070700021)(56012099006)(18002099003)(22082099003)(10067099003)(261009223027099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cVMra2RCYTFsY2N1MGdZSmcyTml6UWRkWUw4NStiY1pWL3FZRW1wODBLcFpV?=
 =?utf-8?B?MHZPN3pRcjJuU0w4WWdNbmtrUE4zQU1CTHdzNHBFd1ZFUml1VWZWWEhkeVFs?=
 =?utf-8?B?Qlo2SXJJNDgzQ21nYzJPZ0xWcjVXazRYMTR5RitkQzBLNGxTdVEzY3lzUk1Y?=
 =?utf-8?B?aWZKcXg0RGFDRS9ZaGJBUmJESS9ZT1poYytOdWNlTjk2ZmozZHA1OGFJei9v?=
 =?utf-8?B?a1lrbzQzaDFFeEdJUnA0eExMUm9zSzNNUFBnNGlKb2RpTnh4aWZ0NnI4RGlw?=
 =?utf-8?B?VTk4MHFGa0t5b3F2RFZtcHRlbVE2ZWFLNmVUT0dqUVVHSC9LRUJrWGY5MEdS?=
 =?utf-8?B?OGNmQU1qa0laSzNSMTdjVVdZU3lVeFpVd1krN3lMWjlCdnFVdUhHdGlXdm1P?=
 =?utf-8?B?Qlk4ZzI4UTFXQy9MeEgvZ3Ryb1l2a1h0cW1qYkhOYWtqVWJKWklMWUhMY2I2?=
 =?utf-8?B?cXErMmFYTC95eEdqVTlqSkRxeVg1NGdQUkxrQ0ZseFVpdjlzUjd2TEFrVjF0?=
 =?utf-8?B?NEczK1JqMC9ZVzErOGZINS8yUHgxSjNIT0I2aWRjcXVvY3VMUHdRU1pKSjBF?=
 =?utf-8?B?ckN6Nm5BYXF5YXZBU0ZuY3V0YXBoUmVpMDNYVEpOelhycFNaMTZ2UGhwelBw?=
 =?utf-8?B?TjBxdzNicWNWL3pndElKd0xhV2RseWF1MmlULzNPZlNzYmE0STZEOS91Zi94?=
 =?utf-8?B?YVJSZ1hqUTJ4STNpUkxjTHE4V0dGRlQ3TW1rQXU5aGxsRGZXamU4YWNwSmgy?=
 =?utf-8?B?bnFuaXN2ZkpmOFc3Y2FSWEZTamZRcGE1S0xmZzVieHlmZTRPMmxzSzBUZ08v?=
 =?utf-8?B?QTY4U1VVNUhKNzJuVnlXL0dCeG9DZU9naFUyVE04NjlQcU9EYitSejQrbktw?=
 =?utf-8?B?OWtReHk3cjI2V3ZmaGxSalhYRG9JcGpuUEtSZHUxa01xV1VCNWpTbHlhNEVz?=
 =?utf-8?B?NnRjQXJhRGgxRlBaUGlKeXpuNHpNd3BSWHhZSnhMalBPRW5yeFF6TzRjOGx3?=
 =?utf-8?B?aHE0b1FCc2pCd1JZR2pZTzh5TUpUc1Y1UWV3RCtieHNLMnNneGZaQnJFMGZE?=
 =?utf-8?B?aW9iU0U1Z042bXJRUjd4dXRyOFdmQlIwTjNuRFcrcG9KSlBBd2dHNjVmVS9l?=
 =?utf-8?B?YXMzV1NvRjJ5WEVJNjhtWXJHampoTFlXSDFIWnJpcGk1aGFXejlLNjAvTkwz?=
 =?utf-8?B?dmpMdUdkTXYzNUh0b0c2ei9UN2d1ZUlRRWtSb09qNmxBQ3JYQXFqWUF3T3pW?=
 =?utf-8?B?azJQc1NqVTNxMk1GYi9rQm9INGhqM0JuOEw4bFdoWGVlcVArVkFQbXpKazJr?=
 =?utf-8?B?Mk1ybjVIZTQrb2NGRDN0TzZMU2VBRmlObzQwb3BkbUxpOTA2SGMzR1lYYlp5?=
 =?utf-8?B?cTRCNVZmU2VXMU1QcytIcGFSYU90Y3ppeWJoaHdPYmx3enkyMmZjRzlib2x6?=
 =?utf-8?B?ZXEwQkdjZmw0NFQ4NUozL2NyejkwbXBFUDk5eVFQQlZrbjMrWGlvN1pXcUxr?=
 =?utf-8?B?NmJOdWZFNGc1dXhTQ0xweTZZRTZsS0l0RXR3TFpSN2x4dHoyWVRKQnFSbzJl?=
 =?utf-8?B?QXJMRGlXSVdMV1pkbHdLRHpzQVlmTktjSEtiK2RjaEtOWURRV2tZMytWNEd0?=
 =?utf-8?B?dG1JMjdYMFZHYUVOZUF0WWsrUXZKWk9qSkg2QTE3am5TTkRUNkFDdFVWeUlx?=
 =?utf-8?B?T0p6Vnk4OTJ4UXg3U2FCTU5RcjN1UlQwc3RhSjJPbXlpTzBXdm1tdWpkWnFW?=
 =?utf-8?B?UHNtTUFMZDN6eWNPcXRjSm1leU5XQnRVVDJhL01ZekZES1lvNDRmYnA3NmRD?=
 =?utf-8?B?UUhTMmZ1ZUhldVk5b0orcnc1SjNBMDA4T0NNaW14SXh5TlhqS2d6WUVXeWNs?=
 =?utf-8?B?ZnRzbmJ5a0FOSjlLVHVjMU1yV0pIZU84bTA4TmRiS05tNGc4bUNwQ2FmTTlP?=
 =?utf-8?B?TXFYblRDR3RpT21mZG83N2ladjluTWV2ajNlb1dKYTVWVHlhOTU1QkR1UndO?=
 =?utf-8?B?Q2hxaVIvdC93cG1WMjJNSnZ3dHM4ck9hYnYxbytMcnlUUjNxNy9qNWpQN0k2?=
 =?utf-8?B?YjZMZmgvcUNQWFhqOXI0azNTSFQ3a1lUVWhrMUZScEJyVzcwbEd5eXd2MVNG?=
 =?utf-8?B?YjRYb3NHTWVpdy9yUTUvVGh2b0Zxc1o1T0RzWDE3NzNMNmgzMFJVWWFUdnpm?=
 =?utf-8?B?a2tJSGdCYmdzUlJ4YkhveGFCZWEzY1pGTmlUOG5wb25QeUxQMUNMdlJkTUg2?=
 =?utf-8?B?WHRKbGxtTXFleWdmOWpDZjJQZU1VOHJVM3hiZGFsZlZzWVI3cWdpRlBaRDR0?=
 =?utf-8?B?akdnKzRVWWltTDA3V3JqSXJ3b2IwUndwZmZBMHQ4VVRreUo0TGNpR1VCRHhI?=
 =?utf-8?Q?Bk3hIFLiVKT2nq+w=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2B3F0A84B5DF7042BDC832F4B8E1ADB9@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	A2nr7bT8t/Cqaa2Nn6fLz3+gVE+Admvz4+SFNIbJpUojPxJ4uQ8cTMp/OhzuC1xShVFFEL1mpxtqu6BwCShWP0vb/VWR8AcNJubbUrDNmBqkCL8nGPgQOKE+zfDTvx2IS8cOzQPCQ4MbMS4Qk0C7yrdOh0ehqTpx/fLpJcKGZtvC0Na01cQPtwlGFR13U8Uw8GiCmEWE98GkeQ/0ay/+2sLDpjvrs0cXVq6LJ9FLf5l3H65jQs0pcMHGCP4zcglPDO3XUcmAtlPdT8BBdJI6srCh12cuXiixTDpmKMLFN5uemvso0vHA4Dgf1QR86C2hxHp9UE1P3QiAZNr23VYUtA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02461b82-e1e5-406e-ecf0-08df2b516f4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2026 06:48:06.8520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n/jM9MyZ7axZyoTQ68WnEqSOvs3c4X+unfXPEmQJojyhCYiA0hCcE30u5p71alj2mGjUFmUHDt3maBqVB1t7UfKsJvz0Zp90C+GaJiUzHB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR02MB11928
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAyNyBTYWx0ZWRfXyI4giuMeuCQV
 D3BG053RiZWMnyxh5FkMZufl4C91AFdaryHW0y8tTOnA+3kqQfn+egGPMUrtafO+FtSQeopS7cT
 SZrIHGXeV2OMk2pLM2E9BpFYMr/8LPM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAyNyBTYWx0ZWRfXzpx3/lwEn3sO
 Bdv0icBFpCXKld59DT9B2dULjDCUpnGD1tEcsyUXGt0E3YF10I257k4cgvPOg5aXcOVvfi1GeEm
 3xoKWN+LTJI19LN/oSLBdngr3ErXZ5WOAkfXLe9VxYzuc3GH7nTmnnZuqahoV8TgFbSPUKqUMIC
 0YSl4N2EfGimBcANSh7cFywcdahIRXlHn266WwuAjv/cv6GCk3k7ocucjZj+ka3VSCnMEHS+ECr
 /PiWV20cnpsiD0vArRfi+x1azuTUIa5FfPizJIYWiV4k9aH1fjS+E9fZR46uoUwyARKHks8FSns
 mdqnbYwDKyJTqPqxffG/LwcUOD74OrMl/pL/aUAz7z12bHJQATtxL+HQzYb6IROq794XCeS5Qae
 nYixo5Gc8RWaxAVOCPCChjsq56F9Oj2Jpa3DVOT09JPA4vygD47oEGdRA04Q4loXM6QzASy0InE
 1hnC3bLNxNLrtGpdw8w==
X-Proofpoint-ORIG-GUID: X7c2_9aQS0VPUbYfQVfQ7SnNdg6ZJEXA
X-Authority-Analysis: v=2.4 cv=ItOL47/g c=1 sm=1 tr=0 ts=6ad1c928 cx=c_pps
 a=5NNvN2rzT21obmmZ06/h6g==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=y4UcunY2MAxhM4LwGdWI:22 a=20KFwNOVAAAA:8
 a=mHAJEDQxa4AdBeop7B4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: X7c2_9aQS0VPUbYfQVfQ7SnNdg6ZJEXA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTUgT2N0IDIwMjYsIGF0IDc6MzXigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gDQo+IA0KPiBPbiAxMC8xNS8y
NiAyOjIyIFBNLCBQZXRlciBNYXlkZWxsIHdyb3RlOg0KPj4gT24gVGh1LCAxNSBPY3QgMjAyNiBh
dCAxMzoxMywgRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPiB3cm90ZToNCj4+PiBI
aSBLaHVzaGl0LA0KPj4+IA0KPj4+IE9uIDkvMjEvMjYgMjozMiBQTSwgS2h1c2hpdCBTaGFoIHdy
b3RlOg0KPj4+PiBBZGQgYSBLVk0tb25seSBuYW1lZCBDUFUgbW9kZWwgZm9yIE5lb3ZlcnNlIFYy
IHIwcDEgKFRSTSAxMDIzNzUpLA0KPj4+PiBpbmhlcml0aW5nIGZyb20gbmVvdmVyc2UtdjItdjEg
KHIwcDApLg0KPj4+PiANCj4+Pj4gcjBwMSBvbmx5IGNoYW5nZXMgTUlEUl9FTDEuUmV2aXNpb24g
YW5kIGFkZHMgRkVBVF9FQ0JIQg0KPj4+PiAoSURfQUE2NE1NRlIxX0VMMS5FQ0JIQikuDQo+Pj4+
IHN0YXRpYyBjb25zdCBBcm1OYW1lZENwdU1vZGVsIGFybV9jcHVfbW9kZWxzW10gPSB7DQo+Pj4+
ICAgICB7ImFybS12OS4wLWEtdjEiLCBOVUxMLCBhcm1fdjlfMF9hX3YxX3Byb3BzfSwNCj4+Pj4g
ICAgIHsibmVvdmVyc2UtdjItdjEiLCAiYXJtLXY5LjAtYS12MSIsIG5lb3ZlcnNlX3YyX3YxX3By
b3BzfSwNCj4+Pj4gKyAgICB7Im5lb3ZlcnNlLXYyLXYyIiwgIm5lb3ZlcnNlLXYyLXYxIiwgbmVv
dmVyc2VfdjJfdjJfcHJvcHN9LA0KPj4+IG5pdCBJIHdvdWxkIGNhbGwgaXQgZGlyZWN0bHkgbmVv
dmVyc2UtdjItcjBwMSBhbmQgbGVhdmUgdGhlIC12PG4+IHN1ZmZpeA0KPj4+IGZvciBwb3RlbnRp
YWwgZml4ZXMuIFNhbWUgZm9yIHIwcDAgb2J2aW91c2x5Lg0KPj4gSSdtIG5vdCB2ZXJ5IGVudGh1
c2lhc3RpYyBhYm91dCBhY2N1bXVsYXRpbmcgZGlmZmVyZW50IENQVSBtb2RlbHMNCj4+IGZvciBh
bGwgdGhlIGRpZmZlcmVudCByWHBZIHZhcmlhdGlvbnMgdGhhdCBhcHBlYXIuIFdlIHVzZWQgdG8g
aGF2ZQ0KPj4gYSB0b24gb2YgYmFzaWNhbGx5IGlkZW50aWNhbCBweGE3MjAgdmFyaWFudHMgYW5k
IEkgd2FzIGdsYWQgdG8gYmUNCj4+IGFibGUgdG8gZHJvcCB0aG9zZSB3aGVuIHdlIGRlcHJlY2F0
ZWQtYW5kLWRyb3BwZWQgdGhlIHB4YSBzdXBwb3J0Lg0KPj4gDQo+PiBJcyBhbnkgdXNlciBhY3R1
YWxseSBnb2luZyB0byBjYXJlIGFib3V0IHRoZSBkaWZmZXJlbmNlIGJldHdlZW4NCj4+IHIwcDAg
YW5kIHIwcDEgPyBJbiBwYXJ0aWN1bGFyIHBYIGNoYW5nZXMgYXJlIGp1c3QgaGFyZHdhcmUNCj4+
IGJ1Z2ZpeGVzIHRoYXQgUUVNVSB3YXMgdW5saWtlbHkgdG8gYmUgbW9kZWxsaW5nIGluIHRoZSBm
aXJzdCBwbGFjZS4NCj4gSSBkbyBhZ3JlZS4gSW4gdGVybXMgb2YgSUQgcmVnLCB0aGVyZSBpcyB2
ZXJ5IGxpdHRsZSBkaWZmZXJlbmNlIGJldHdlZW4NCj4gYm90aC4gTW9kZWxpbmcgYSBzaW5nbGUg
b25lIG1heSBiZSBzdWZmaWNpZW50DQo+IA0KTm90ZWQsIHdpbGwgb25seSBrZWVwIG9uZSBOZW92
ZXJzZS12Mi4NCg0KVGhhbmtzLA0KS2h1c2hpdA0KDQo+IFRoYW5rcw0KPiANCj4gRXJpYw0KPj4g
DQo+PiB0aGFua3MNCj4+IC0tIFBNTQ0KPj4gDQo+IA0KDQo=
