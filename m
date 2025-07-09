Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2077.outbound.protection.outlook.com [40.107.92.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05A6291C31
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 14:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752071690; cv=fail; b=MYRCcCLOou/cS7PGX/YNK2c7yq/04htXuZl01lYEtKcZx8+UkgHjHWSQUVYzYjZdLl4Cn/05LDQeF0jKIfbrHx4EA9aXFbhYu1/QSL510p3GRK4l6OQT7vdSfadPQX+C6njkBusCJLRi9ZOAGU+eYLqZ0s4LF15PkpxhyGbut40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752071690; c=relaxed/simple;
	bh=ACKXn6/IEs6tRtVJBuHycphAoZQpWBEb42fawdXdY7o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hWfkLF9+TmwhDbiSmIxPhu3VIeOzbT/JcFczLuG2PwFD5ZDTX3olha8Wdb9SOfX9PSclpnorn+22fTC9tIQ9xVExokK19++OpI6S4WZViM6KcVc4MZiXFrRofpDLh+0eCSdh2IqyeSbGwFmUV4lf37djgovKyPlJJkAZ3mnZXHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YPvTJ0rU; arc=fail smtp.client-ip=40.107.92.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YPvTJ0rU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u760nqaTG2KE0TCBpyLiMr16VSFWDT7/ILvSS+ZtMLXbJPkF6xF7aei8kgxLd20SCHMsIdy14xtSRKxHBD8+MltG1kYtnhRuj2PJGezG2uAwJL+n4bT9TTuH1FqO/IIMb23WEofIEPBiIAgyTEnP4PvU7MpxxZMwlVHGHeZpYDCJx3pgeTOegq+SvwBeoWMpBx9NSkwgI0sJA2oB2toy+kZTxCs8r7oo9bjLIxfJLAXVByxYkeCxatB7pHm6xyVaSdj7ErzggXhYBkT20u/pOhAHXI3YfCUSWFEZpI9VDg/uuh9KudPIsXySMpwgn6QR2wN+yEoaE9SVlSz8+I1qDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YA9ivAX94wkUHX4IeeI8ANgks5WUKHZDn/Q6gqwvwyg=;
 b=l2klY5AkRR+Fed6CsgaKi13ANzHOqF0OS/OkvgJ/9S/W0/NqKp+uqVDaGEQHuxxbTwWkDXQhELvi1FCP95txlCycmZLbeGeCLJWUHSn7A0bjhBH1GN7F3JcFlQJ8y9unwKMYEdZmJ1k4cKuAK04IXRr7+vmvebb3N4aETAvq995B+cuyyewn+wChl91MRfZhWijVYSTAGcwWO5E4HX3V8q1aC97rN5NxPHZ0dGlsoFHZoT3qN7K/z+ndPDQSEOKtVm12uyAM3fJkjiexPMvuXaBeK6VLNM+XTXwmzX7nUNwEm2bpEp5SS0M+coRN+iEXL8nhdWAdmwgvZF6oFGtpSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YA9ivAX94wkUHX4IeeI8ANgks5WUKHZDn/Q6gqwvwyg=;
 b=YPvTJ0rUQHgOSQa1a303yDahNEo8uPLWLgneo25vMoThh5iZlE2jRPuBL96L5ZK4TXU4BZz1SbKV40JHranhtZtk0B0Om5rwTWyEJv9C89MQ87l4AWmQeUJ4LH83pR8q29TpV8eaFX3kC/XUloXveG+qs1Md21J2PSIQirhWakvZZ0AkR1W7spsKBXA8r1gWVCi02VXtBwW6OVeUfh5ijR57FihP9acHZjVAfk5+Q48FL4sXCb8v4mGG9mliXJYqXcBjLyMpR59/PTWM8I4juaizYVMEIzhzjlq4gbRgEHKysFMaLONZAeXfzM/eVLggvRQ2R2xpfc8hmQF4gad5cg==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by IA4PR12MB9762.namprd12.prod.outlook.com (2603:10b6:208:5d3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Wed, 9 Jul
 2025 14:34:45 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%3]) with mapi id 15.20.8901.018; Wed, 9 Jul 2025
 14:34:45 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Oliver Upton <oliver.upton@linux.dev>, "maz@kernel.org" <maz@kernel.org>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org"
	<will@kernel.org>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, "david@redhat.com" <david@redhat.com>,
	"ddutile@redhat.com" <ddutile@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>
CC: Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti
 Wankhede <kwankhede@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>, "Tarun
 Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, Zhi Wang
	<zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>, Uday Dhoke
	<udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"sebastianene@google.com" <sebastianene@google.com>, "coltonlewis@google.com"
	<coltonlewis@google.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com" <gshan@redhat.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "tabba@google.com" <tabba@google.com>,
	"qperret@google.com" <qperret@google.com>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>
Subject: Re: [PATCH v10 0/6] KVM: arm64: Map GPU device memory as cacheable
Thread-Topic: [PATCH v10 0/6] KVM: arm64: Map GPU device memory as cacheable
Thread-Index: AQHb7Xzh2Hcw1h6RA06LwUDPmEcqgLQnWtIAgAJ/Wi4=
Date: Wed, 9 Jul 2025 14:34:45 +0000
Message-ID:
 <SA1PR12MB71991654482239855DA01D57B049A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250705071717.5062-1-ankita@nvidia.com>
 <175193253138.1687959.6241606194423745301.b4-ty@linux.dev>
In-Reply-To: <175193253138.1687959.6241606194423745301.b4-ty@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|IA4PR12MB9762:EE_
x-ms-office365-filtering-correlation-id: 793fdd59-2f64-4664-9c1a-08ddbef5c011
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?X3uYg1z4blU/8DCp2+iiD8ZWQtr8PbyhI8Uv6FvfXptea+c6UOaogpJYpt?=
 =?iso-8859-1?Q?hL49DEHZ10wq/EskqNUsgBDwrT1f3ZtdsuDEbhb29Ix8Q571yOeEdEdjWG?=
 =?iso-8859-1?Q?KnjVTAJIb94AeaCczc0T1PpfDWSHC20DC/Whcr374f4Jv9ACm9RNQrr2IU?=
 =?iso-8859-1?Q?d595EtOycj5V3+vo961Lv3W7K+HZygLLbZDvqPOnP9nkPrEdAgfZrJ5epf?=
 =?iso-8859-1?Q?W0Gt7alxLzuoSp42UDL7k65HDubJAhpEx1wgZAUjcbCTRvhld0HIIOVf9t?=
 =?iso-8859-1?Q?SMpcoSRzhZiNCSVrb9gjzcvXv2iHKx75SnuRQZEjE9HgLQIZ4ntm+KT9+l?=
 =?iso-8859-1?Q?s7iEOXDCLC1ub/hTuQnE4K2SmQW0ZxmPUf5IzLmxsXcJ0fmgq16Zz/gCAQ?=
 =?iso-8859-1?Q?7eETrUZaAW2SzE9zmU0jBfpfJdtm6gzJM2JtBL4gld0fGlLcRhB08dVi5h?=
 =?iso-8859-1?Q?ox8yHime4TiKrwT9Nm9SNqB8E2NNaoxIHunXVd3GrGMvSzbC38XluFMlg2?=
 =?iso-8859-1?Q?xPo3Dz4zeufUIeTOxhilYlOzvS8cUf1RZSIdzSUSvogq5EnrW94rkWrpld?=
 =?iso-8859-1?Q?kn//TaoP1pxNp9Qwxbi7Whs4oPC5jczKcPj+TixV96XHcii8N+kZ2SW/1D?=
 =?iso-8859-1?Q?UNZq2I0eH33q6uqK5bbwXv7VrGuUTAIYEYay1wrTXrXo/FbTbvTmyToBqo?=
 =?iso-8859-1?Q?2x6/ZP20LW9c2VuAqp002121RuWdHdZnxy4HdE+QUiYFG0h/fW7UsUgXtQ?=
 =?iso-8859-1?Q?faSdyrqcce4NfGIfNBWiX3cpk6yng2PSefcxi8dOJQPL25O11AK2e8Xcqr?=
 =?iso-8859-1?Q?xRsoltPptUG80y99YwlFRkHmqNWZeKVrktCWCea7qcOYOFkAn99jBNkJYm?=
 =?iso-8859-1?Q?80/qje9mxMYGhG3Yw4s+nboOZvyXrTJYUB0X/pKGQYSx1er7MKb+Cb2Ns1?=
 =?iso-8859-1?Q?fjcRz2hLCxZdsulW2knsOU6VlqnYDQmmkuPR/uLC7AbNqLN/a9qgAHeLlN?=
 =?iso-8859-1?Q?9Y9/8hOoqRvitsKaaLqDTy5v6QmZdHIko8n//IVAGfaLNCcO6+jt+iwTIO?=
 =?iso-8859-1?Q?NOcQl71Qp5zOsXdeaXp98MhV+Ah4qCM5BE/tzge3ZPHrf68hr+thN18FZC?=
 =?iso-8859-1?Q?9FaCpi2b6VqxSGQHROrRlokn9ZoH4VqOyjTyubxteth3ENy2f6Zer6nda1?=
 =?iso-8859-1?Q?q8o4rILDtL7o0muJImM+B0TDmsvSB7RoZH9cN6dtzRp5xEjv44xWcq2Z2n?=
 =?iso-8859-1?Q?XKHrTO6qWJTuWuouYPQ5TxyU67XZl8sqO3eTerpds+PLFzt7PK+tmYmbi7?=
 =?iso-8859-1?Q?BbqPFw7hVq94VQTVrL5kR4kHhWmhwDx5upWXJnBpt/8z9JtvxuOe/LqWSd?=
 =?iso-8859-1?Q?sva1Fl/z8VNc7o4Ls+OwOMNOcMcK5n22YB02ZuYRQgYv+tKeL/uGlxUamv?=
 =?iso-8859-1?Q?PiAdNKu4pHf1+JsasZohKyYxdDyPytpL5TcReRdMG4NBeV0DJju6Ay8b6+?=
 =?iso-8859-1?Q?SanM3DIxDDZaHN9QZuvnj2yqaEY0N3cLU43dcuN9Ab7PPMwc8vFjag/oQe?=
 =?iso-8859-1?Q?x836d4TDdkVWzB+eoRYcfKN6ETfO?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?RYIwRh+aNKjX12higU7uhw9dtLOeLi/kjkXOUZKXe+t5Fx3L7FMmCYb9uf?=
 =?iso-8859-1?Q?PATf051oj9DF7JbNt3bGtxR5jQNiV+8LCstbRNVI1GmAOvoPLFo9tHqzWS?=
 =?iso-8859-1?Q?BGumdP5ONrWEFQO3AfEepvL/YNbbJW4br93b6DCoNvpR/iDm8xaRdtPsfc?=
 =?iso-8859-1?Q?KTxfHWmf5U7+eMPyFZGzeJzMQKJH435GreH7iXw73H+bu/ilsd6BbYxyHO?=
 =?iso-8859-1?Q?B9VFnHmo0wEErLn/EE9z3CN7nC+fCTi+ievbsyyC7PyM9jC4X6FED9Tbt5?=
 =?iso-8859-1?Q?tjdIW+RM2YRP2ayrMhX1/ibp1dmepd6QLiuf3ZToaQYx/wm03/j4Vl5q+m?=
 =?iso-8859-1?Q?5oHfAufW5HUcgkXoMf5qUCJD0SduGAHTYJm3VLs055tR+vmBIqxFnSkRcw?=
 =?iso-8859-1?Q?c6GiwBjIiFFBzNPAy7qKNouuGZzsMVTGZK1a4R8mquw5CEq6j0aFG6zwgj?=
 =?iso-8859-1?Q?YIISxDcPeQlO2sWEO0NHTDEpOfL8gTjzq+JON1/HUHyi6sjLOru5bIOmdj?=
 =?iso-8859-1?Q?zQ10JNGa9WnbdH1C5J9IX6Y2WhHiOVJ17M3r0f/DW/L5nyquD+OkKEvawp?=
 =?iso-8859-1?Q?cJOiPk0irgZuihsnxxlAihFfQqAo38MwVq+cCzxS2xWJ0pe1gLKRyh1bDs?=
 =?iso-8859-1?Q?9ufmHfhTtZTvVx0gXAMV5cjNBapSG7+f12MlZAIQ3LZF8/m2fw0z086aik?=
 =?iso-8859-1?Q?aqLk+I/JTTP3XdGfhp6Z3OIjVELA4+J8mU29bVkOoBt+V5A9U6jKqLvFG3?=
 =?iso-8859-1?Q?AJkKWhEkUwlb+O5oCxLE+uJ3lBOXuMx+mrBJiDPkeB+ZIlt3fQD7ShxChB?=
 =?iso-8859-1?Q?sPNswRi/uXUxnNzJJEYjLM/zr2hPf9F3cLK9UAk6BM/ggm1b18jPgxuviT?=
 =?iso-8859-1?Q?xSa6j2LtekanRlMUXySjs2BaC0uzcxqHB6DqJGAbumM3P19WKgh6VtWnui?=
 =?iso-8859-1?Q?saI0qBz2iakiiaVoqwVZtd5lOUNlZkR5gpDXC1X21LAyZYLpTgSYINrxEk?=
 =?iso-8859-1?Q?LH7fz6d8xNaq3mUNvEEswkMaOEa3PXae5gRt/5XU0oz1S3as8r0JUQkRwb?=
 =?iso-8859-1?Q?xrEE5reusocdpeV6C8HT4V7YjWa+pmf6U/DWqEzPertD3H5vCI4Me+tZfp?=
 =?iso-8859-1?Q?oKERhPkeu86hpihT+xQWQX6zjLAZgqcUsfdHOqSuEuZPQgyYzm+gzqPEzO?=
 =?iso-8859-1?Q?RakKQHWL2K0mldhmIS4UOgQ7OURMY5mjsFtpsirnoaChtafWmkLjdbll0T?=
 =?iso-8859-1?Q?eoC2gGlYFBLcAkAuJ9Et13T9t3FkR1JRldI7SZEqOfmpuD7nARbbCt/mmr?=
 =?iso-8859-1?Q?u74yx+AQJf6uSbn8xaZVKUdY/YJ2EyUvnjsKFP09q7NsNohBbpV4TD9s2U?=
 =?iso-8859-1?Q?yN515FwejR0okbbqfmAeRu3IXNIXMcfahmgbkFMOHqB9TkjZG5P2MZh7qy?=
 =?iso-8859-1?Q?v2+jP878DH1D8HO2oGH9VlQB2Z0IY4LnVShF1UTzilOI4V55hA9Q3SuqME?=
 =?iso-8859-1?Q?oKG1wAG/gMZ2euKa2PW1Lo1WInn1jQ3vS5SaF2Vqsw4uVEPPmcIOLSzc+o?=
 =?iso-8859-1?Q?74TWt/rJy2q8KaedvFLnQN91RxJ1xbG987jJ7kgDOY0zu1Iw74qhQO4fxm?=
 =?iso-8859-1?Q?isN71eFi9EqWw=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 793fdd59-2f64-4664-9c1a-08ddbef5c011
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2025 14:34:45.4941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q1nYGNkFC6GE+RjyywBJ7R85PltFMyQc1us6v9ggPpXZZiQDWzrSwNU/saZU54K7ruqz9jf0HTMgUCTu9yYczA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9762

Thank you so much Oliver for fixing the series and applying to the next=0A=
tree and also for your feedbacks during the review process!=0A=
=0A=
> I've gone through one additional round of bikeshedding on the series,=0A=
> primarily fixing some typos and refining changelogs/comments. Note that=
=0A=
> I squashed the kvm_arch_supports_cacheable_pfnmap() into the patch that=
=0A=
> adds its caller and unwired it from arch-neutral code entirely.=0A=
>=0A=
> Please do shout if there's an issue with any of this and thanks for=0A=
> keeping up with the several rounds of review.=0A=
>=0A=
> Applied to next, thanks!=0A=
>=0A=
> [1/6] KVM: arm64: Rename the device variable to s2_force_noncacheable=0A=
>=A0=A0=A0=A0 https://git.kernel.org/kvmarm/kvmarm/c/8cc9dc1ae4fb=0A=
>=0A=
> [2/6] KVM: arm64: Update the check to detect device memory=0A=
>=A0=A0=A0=A0 https://git.kernel.org/kvmarm/kvmarm/c/216887f79d98=0A=
>=0A=
> [3/6] KVM: arm64: Block cacheable PFNMAP mapping=0A=
>     https://git.kernel.org/kvmarm/kvmarm/c/2a8dfab26677=0A=
>=0A=
> [5/6] KVM: arm64: Allow cacheable stage 2 mapping using VMA flags=0A=
>     https://git.kernel.org/kvmarm/kvmarm/c/0c67288e0c8b=0A=
>=0A=
> [6/6] KVM: arm64: Expose new KVM cap for cacheable PFNMAP=0A=
> =A0=A0=A0 https://git.kernel.org/kvmarm/kvmarm/c/f55ce5a6cd33=0A=
