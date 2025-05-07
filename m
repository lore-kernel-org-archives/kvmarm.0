Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2047.outbound.protection.outlook.com [40.107.212.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBFD28B3F5
	for <kvmarm@lists.linux.dev>; Wed,  7 May 2025 15:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746631576; cv=fail; b=K7jmsAyYVHMFR0k0YagvMeUgJv6w46yY831Yk6paZPpAIKyz3iCqsNHkj/D3NIaeyuT46e+jWQBhqrqoehg2P0EE8F3NHJ6vqCNUVE8EaJ8+SUwBfplxgcy6X4wWy6vQ2Mn2kSVEgDvkVTsAxY8XM8cUjMAH4rraWH0F+LvDs9U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746631576; c=relaxed/simple;
	bh=u6II7M3TDKNcHgyiOTNqC9a5PDw55hD0iXRUv8izYMI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QjCJlQOP5eaWb98TWA/j7a8Y8yCv7zyLhnkPDFvG+Rs1I2qp9/jG5zjj0iPIn8mysslLnNcMl+dlMWlLHpKLrgW9FADJLquuWPYfWXqMOkWyM75weTN2CmbJM7cWtnuRl8KDD/ehUWCg7ssaspyJ1GViEJScN2f7E6U9bphI16E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AdJbgzKr; arc=fail smtp.client-ip=40.107.212.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AdJbgzKr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mqQO4EPtC2XlyIf6q4M+H9WIx6k9Xnfao//mrkLUdqcd2vYlAsst7TC2yA0qDUeTfl/TLM8ay9AXRiveVyXZ6nYMYQpOoeqlhx1unYYZpPg/P+AVSteTTDgJLKgGq6SKN/Q7q6uguFhvigkPKNzDz9ijmFzZwImNZROG3NR+6HvJ+pI1ojDQ0mqV7DSrTop5Lfbuhqy0EMUcPGq2RSkMSCAjqsfH4tq4VxoNwc1yoxYlzWAuv7FTSoRh3yK08+prGA9I+x9FkOY9RIdgEY+81pQx+AzwJnbYqcYo81tJI9fC1gLxfCm70DTJlE/2F++eVHEKsVMKLwIIvIuXcGYHng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u6II7M3TDKNcHgyiOTNqC9a5PDw55hD0iXRUv8izYMI=;
 b=IYwdtZbw6tA5xswINgKMvqZcTdQiTYLNyifpn+1I6juzsTmPxS36eHB8GQWYj9DESB8uagTbLEfSDbicZC2MFuzKywkwwqGgtYqlw0xnoeVXljzO1DVEBx4WXvEC/1uT9DnmHCWnNJJCcDc5C2IxgW/tR1Ubh3LWdsDMjePJBRRb9W5iwLoHam0BZPYwmskev/5MoIpTThotP0geBlTYmS4jg2WnuL3XW3a5WjyQf10BoRFCbsY+FrwEWmuo9uhiBtjszkyE4gRgvSUjV9zIIrTAZYMnwQXgf2wsVZ/vs9U7yQ97Edov0rruD75InteYOtZRHxPaH+v4WmsKpXZzcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u6II7M3TDKNcHgyiOTNqC9a5PDw55hD0iXRUv8izYMI=;
 b=AdJbgzKrq80gHJL6KBbkEJ1mBu/GbsVeT+tGyRQm09yjyAO5GIuzTXnNDjdpoL63EUNphGHvN16SbS/KOGEDkTwx3wrHNfI1GllW192oVZM0zNPmE27jOF2dEqUDl+5EnptynvLhCrNf7bNUHrjOqFAxDoLGFk6ihR15JliwXWFZmH4EMqkeKKTdfzEZNrREkk+faA/CIHsw7McXvhEooq7iN4O54BGM8iI9EUhIFqj98vbLwBAf9eP3va9bDiEUNnpsccQyFNYSCzY4CHGnVOwQ48ap05BvfwwuwuyTo7Wbc1isqilWwOxTwzndkPdXf/eME/Ud5do6YlQ4ILDf5A==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by BY5PR12MB4114.namprd12.prod.outlook.com (2603:10b6:a03:20c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.20; Wed, 7 May
 2025 15:26:05 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%3]) with mapi id 15.20.8699.026; Wed, 7 May 2025
 15:26:05 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Catalin Marinas
	<catalin.marinas@arm.com>
CC: Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson
	<seanjc@google.com>, Marc Zyngier <maz@kernel.org>, "joey.gouly@arm.com"
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
 AQHbkaduhEbbxySPq0WwO4LU4q6wXLNsQygAgAD/GeCAAIkeAIAAC14ggAFVjACAATjx0YAGtS0AgACvDoCAAOaHAIAANr+AgABucICAAD0IgIAAg/iAgACoeYCAABKYAIAAFAsAgAAouYCACiALVIAAbFcAgAANkACAAAgBgIAAHy6AgAAGMwCAB6GYgIALBt6AgAAPgwCAAAfeAIANn5WYgAleFwCAAGYXAIAAMRUAgAADmACAAEoDAIAAI6kAgAC69ACAABWygIAABr+AgAAKNYCACUShlIAAL/cAgAANTICAAB5dAIAAC4MAgAAXzgCAAAK4AIAMXSdJ
Date: Wed, 7 May 2025 15:26:05 +0000
Message-ID:
 <SA1PR12MB71992BC382DA4ED506100590B088A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <aAjEsIwhYQpkphrW@arm.com> <20250423120243.GD1648741@nvidia.com>
 <aAjci3rddHt_R_x3@arm.com> <20250423130323.GE1648741@nvidia.com>
 <SA1PR12MB71996988916E1FB15149DD13B0802@SA1PR12MB7199.namprd12.prod.outlook.com>
 <aBDTpu_ACoXAPoE2@arm.com> <20250429141437.GC2260709@nvidia.com>
 <aBD4RsUZp-BmcLwC@arm.com> <20250429164430.GD2260709@nvidia.com>
 <aBEV5gxYoDFct9PC@arm.com> <20250429181926.GE2260709@nvidia.com>
In-Reply-To: <20250429181926.GE2260709@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|BY5PR12MB4114:EE_
x-ms-office365-filtering-correlation-id: c5cee8a3-3241-4161-ec16-08dd8d7b7bcb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?lFSoHVAgEyW6l18lIjY12tsG0f69g7gCiYqYsieYoBixwRFWtJ14qA0AzZ?=
 =?iso-8859-1?Q?UPHm8nigqVf2tA2fmfSyy6ytSGxqrztxEBfXpQgJZH4qwsC8ExsWKNd3rB?=
 =?iso-8859-1?Q?l1Xk0PnO+lUmktx9FHNjYUh4OU5NadCyhwZJboE5m9P+EDm0YXE23DDeKv?=
 =?iso-8859-1?Q?xFfug9WiGweUx/vaY7BVnjy0C35f0xB+dXk6D8OQqc0dmGrXs06phKYjyh?=
 =?iso-8859-1?Q?IyqiAKxd8IYg81hzotAQ9Kto1ZmZd3yYOWrTBfciUfquCjoPiyMP/G527v?=
 =?iso-8859-1?Q?SpFIQ05pXJpOPrClHkktzwASCnqVlBzACPDDjcCu6iRNLtaaqfT6sneEnM?=
 =?iso-8859-1?Q?Z233dMCOtA6VB6BpX8Ak2xWFlgKU4CwDvurwihM2WUHqHtCeExGJq1G1qT?=
 =?iso-8859-1?Q?IE2ZhtcGjuCuakmvGG+yqezhByRsN0r0vFJIhSTX5WnUY2ufRcKv5B5B0J?=
 =?iso-8859-1?Q?xUJ/5wCR7MIeukjogAH+pn2xps2b4FjeE5jingXzQJTFwVsAri7mT6C5A4?=
 =?iso-8859-1?Q?ViAJyRdWWA6ORrDB89/SKSRNlDDH4RE4olfj8Wb1qZspS8W5VUmZym2y1p?=
 =?iso-8859-1?Q?Tla73TUijjJ15nwmr4YmR2MTzoePDBv3bZMiw3g+UjwmuyHb0O5cMA320G?=
 =?iso-8859-1?Q?OKbWzUW3fSqsvSs4E/LfYeP9vuS3rlue3HSLld+vuqF7DbRpS3MlZNNvPI?=
 =?iso-8859-1?Q?/AlJbp/kAvdEEhkhFLnneqJJBYv26QnzMyKHh2QTzZRMNRgE66KR9D7WyF?=
 =?iso-8859-1?Q?HZMD/ofoXFNkReOyxSExqPE+0CC27CG+rXqO/QaI7Yfxs9Kqdw1kIt8pK1?=
 =?iso-8859-1?Q?qHcOj9GnZjkfHqSx7AYby6b1EZKxNtA4Smb7Ga93cPaD3vzGxqmqlAo2pb?=
 =?iso-8859-1?Q?2M/86xKJmbIq+zO0YFVcwSSu8hFp1T0IFTQ7K0iqUMIFYskh/BBmxY9ZFT?=
 =?iso-8859-1?Q?2EGtn41IxCpJlwqSo2yzS7lG6/O37z44cyE/YRKI/+aNdOVHHBmX/kLQlk?=
 =?iso-8859-1?Q?QkF2dSBETxAFSgFRxoCr7KiRjyyB0XXoP2L8i0x13Q0uh9+8SuZ7GcilFd?=
 =?iso-8859-1?Q?vYSvaQevaDRDZ7Z6iID8/FtcpEQHcIWlHJ6FSzKypVai3+YIMio7AyAOz5?=
 =?iso-8859-1?Q?9+Tu5MA02MaJl4acn4q0xaqavE6DVAOiWGOumSeSVMHOh9p3kmJGRzviDh?=
 =?iso-8859-1?Q?+2A+fKIO/UFWfWvib/2HDPZlIFP9CMbEeUg+uZglj+FKpK/Wlo8LsmS863?=
 =?iso-8859-1?Q?igyYDUEkHd6kWMF9/HWNhUvxihygtuWtm6kWi5Bid9+snDUB4C3M1VdstJ?=
 =?iso-8859-1?Q?VyaFh+AJpD4Ec4Iv+TcVzmojUqNwoN6nvrNqc95wgsswaHUuV1q32ovwD+?=
 =?iso-8859-1?Q?FhSSFWiCDNOXtjEfFTKvLe6j5kVMJ/gcgO6KPS1GU8l6wkzDgTimlDRUPO?=
 =?iso-8859-1?Q?QdwQG4qEDwrWUAcMNUgAxsggrtv2+VXmZ+qzmuylclu3qZxhUM1qsYLMrn?=
 =?iso-8859-1?Q?p8p3age8ApsDM7tb5G9arbX21dEqF5J27LwvMEm38TSw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?R3PVnni90ukwE2ujD7IW+FATdOl07aYnCZ73JIhhv6iJYU8EbM9LFnzhId?=
 =?iso-8859-1?Q?kDECQzu5uJlI2nOkn9diOy6kkB1hmdjHMqDOZuj65sPQxEEY0C/7U5M7Bz?=
 =?iso-8859-1?Q?ih/D7Hp6JcicslpcGB+Qo3+trMzbDU2SzKj/BYdB3KKhwF2C7GUfadXQKZ?=
 =?iso-8859-1?Q?i/Oq9h1H9glJY6EtEwRm7gt6FR+MDZwwyn7YWOeqg15Gb7lw/8gPKyKZ1v?=
 =?iso-8859-1?Q?iKUk80ldOas/qkSEDl5OZRqtBDS+qj7eK8k7R/xEKZZu/lOCq9OIeZmxX7?=
 =?iso-8859-1?Q?Wofm3OEIn2MmxXMMhAlM5WQWMaiT5wX3rImHGEv0GY7r92WoD4M+qccTKQ?=
 =?iso-8859-1?Q?ZEKIEcYcaFhDJX+YWGbGzCJzDNgIySGl8EsFGGRxSMnw2zyMjIfXXqypTP?=
 =?iso-8859-1?Q?CNOiSFCFCN+1VnTeNOuLmML1e4CYHTv6vEBTVu/x72pJYibmxjvoTFxS3A?=
 =?iso-8859-1?Q?/cBzx/g1b3FVqXbVbUrff+bt1gBNhO8owmx6+dn/O6UcUgGASYpeSTyW/Q?=
 =?iso-8859-1?Q?kBdLq/fbvyOkRAPNjY2z/EQCBoZXZvgQJV/UBAzLqF2VTFXAlb3NP0vWqc?=
 =?iso-8859-1?Q?6AIHxE6gVcSntfxp6X20b/sjqlxKCg46RsFaH/U5ADmElA2N0I24beFz4Q?=
 =?iso-8859-1?Q?KaUrsFnm6eb/uqOnf6BXnIMEny5vxFTfWl/He4Poxf769/85BUY8Ga/Sy3?=
 =?iso-8859-1?Q?4tO+dvkY8SsBCGVICh3UueDFvfMCB8Whlr3RYSqpQ9q79fwQVtdpKlyCmm?=
 =?iso-8859-1?Q?rx5jcYD5UobKbDP1TdknuNHvedWBqWxVx3zUMYwigbs3jCwjQOkI4NfHUQ?=
 =?iso-8859-1?Q?qdM+Y1Gd2KoDTgdeKrGvylSXlOa6gYA0bhzrBheYqfSu4a5M45fNA3I++o?=
 =?iso-8859-1?Q?JLjla+/NtZEgYXVJkBZbggPT7KL0wb0QXsI47CM2kaC1h49fC7MRmslCea?=
 =?iso-8859-1?Q?tpIk0LBHQJXFHy6ODGyfzmqOGxOhMZFCChzbDovNSKQf8X9msBX7aZ47CB?=
 =?iso-8859-1?Q?ywCqXZgGkgstdfNpmFZs0GBVntGbFWg8XpAPFy00R7uiHml1a9XYWCxz0X?=
 =?iso-8859-1?Q?w/M0lYvf2dec5Cwf9InNPF0x4Zl5e5MihQujgfhEtnsYm4OArGpc6bqUI2?=
 =?iso-8859-1?Q?nWWJGh5rDUYv6BdDfbGgenTvuEPioqfXuJcZgbiKn3+C8g4Qd9WgeFXv1d?=
 =?iso-8859-1?Q?xu5Crb3ciqChiVLGEgxb6TT/L+KFgEGXpFjrtJCBHsk5fa2BvYIRUnYW6m?=
 =?iso-8859-1?Q?4BWu0El4q5hPKjB0WODNZIQylYn8GVdMo1G8OeAr9Ic+v9mFxeImPg9sTM?=
 =?iso-8859-1?Q?uJrVowIZzbr7paGmzn5DwiVh8WTz0OOPGpSKAcch5UoigDxcRGEoxHQ7sh?=
 =?iso-8859-1?Q?cJEhw9Z2XjbkDWPRhX9hKpu/IvsaumuiDCmqKfF5AMSHfIb/0tGK3JXREe?=
 =?iso-8859-1?Q?Xc6X7qvgz2mGkhG0jN22KfwAQK0Xj7Yk2Iip7/jotRe5Ez6119X2GpmS5V?=
 =?iso-8859-1?Q?ggy6CCFuP+54SEUpIAfUJMS6/lno4IjYZAw/RDr4JTJAsW+cxBAJ38kYxf?=
 =?iso-8859-1?Q?guxvZRszdX850pQUXyTESj3K4gxVI75/teAeuodzUHwjpEtEx0bKfuWf2h?=
 =?iso-8859-1?Q?seFZtK0ANGLgI=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c5cee8a3-3241-4161-ec16-08dd8d7b7bcb
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2025 15:26:05.3467
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dnd/Ov1XD4Za5eoJJQISC9dT9xSAZAtxwMylwodTj0A1O5cDUOUyraBInEczaViGplJxvXBDbpAbO+6ZtOlXkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4114

>> Unless FWB implies CTR_EL0.DIC (AFAIK, it doesn't) we may be=0A=
>> restricting some CPUs.=0A=
>=0A=
> Yes, it will further narrow the CPUs down.=0A=
> =0A=
> However, we just did this discussion for BBML2 + SMMUv3 SVA. I think=0A=
> the same argument holds. If someone is crazy enough to build a CPU=0A=
> with CXLish support and uses an old core without DIC, IDC and S2FWB=0A=
> then they are going to have a bunch of work to fix the SW to support=0A=
> it. Right now we know of no system that exists like this..=0A=
>=0A=
> Jason=0A=
=0A=
Catalin, do you agree if I can go ahead and add the check for=0A=
ARM64_HAS_CACHE_DIC?=0A=
=0A=
>> Another CAP for executable PFNMAP then?=0A=
>=0A=
> IDK, either that or a more general cap 'support PFNMAP VMAs'?=0A=
=0A=
I think it would be good to have the generic cap that is safe for=0A=
executable as well.=0A=
=0A=
=0A=
>> However it appears that the memslot flag isn't a must-have. The memslot=
=0A=
>> flag cannot influence the KVM code anyways. For FWB, the PFNMAP would=0A=
>> be cacheable and userspace should just assume S2FWB behavior; it would=
=0A=
>> be a security bug otherwise as Jason pointed earlier (S1 cacheable,=0A=
>> S2 noncacheable). For !FWB, a cacheable PFNMAP could not be allowed=0A=
>> and VMM shouldn't attempt to create memslot at all by referring the cap.=
=0A=
...=0A=
>> 2. Enable support for cacheable PFN maps if S2FWB is enabled by followin=
g=0A=
>> the vma pgprot (this patch).=0A=
>> 3. Add and expose the new KVM cap to expose cacheable PFNMAP (set to fal=
se=0A=
>> for !FWB).=0A=
>=0A=
> I'll defer the memslot flag decision to the KVM maintainers. If we had=0A=
> one, it will enforce (2) or reject it as per (1) depending on the S1=0A=
> attributes.=0A=
=0A=
Marc, Oliver, let me know your thoughts if we should add memslot flag and I=
'll=0A=
implement accordingly.=0A=
 =
