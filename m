Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012042.outbound.protection.outlook.com [52.101.53.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7121A9F97;
	Thu, 10 Sep 2026 22:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789078725; cv=fail; b=GbHO28fPTo5cirITdhdw+YZrheLGcSev5m5t1jAWpX2JGGvMVY4+KurDlznWVZFfErfC02wCZs0lO0i/inz7y+WmslE8IJuSy735EOgwYtJzsAh47fMB8F+olTfm4W20Wueg/ZJ58aA/1OYdMQj4sOU07B6mRSQRrhnwJYeBiyk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789078725; c=relaxed/simple;
	bh=skSZMJCxx5hkdKhii/CR8+Hb56esOFV3bhF6MfbbNWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uO+l4LNWdUbWy5/8TTZu8NId0FrNB5wYW7L7CdcX4lgbPkU/eldy86cSRKgBEhoPGr55D5E6KB1O2UbV9+zLiIjfdQPpuEYO10HwNr73Y8KSIYlNerZga1yPXWC9ulS6Osj5cwQZw9Sp+WZWj5sqYc5RtZYN4iGFy7sqCctN+oc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uQVXA4ZP; arc=fail smtp.client-ip=52.101.53.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uQVXA4ZP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wHrARG1sxBtLue13PauEtIp4t1lYqz19P2FbbuiJbKcWeFYPvxkPQDHmGH7dN050Z6OHI5xhn7J0KT86X+hxcq0uE0XjHWWFPH55jFUi8WXcIyGj9Q7p3Yp+nDRqo2aMKonMTKg8sOC4s2SX5lw/zaJfoCqf+SCYPJH7+CRiehpCGkmXWgjuUUTQUXWO/R7F8CU2BONeHYThkWz66QH5xk0VPpVFpfdseLXTrybr9nYO2+am0w5ZbZbrStLfWiHgiWTVCvkH3Ti81tk8VuQ1PZHja4u4kGS3ZsNlh3lNFP2me2Yu+XlR/qFTx8j0yYtQVzbhVGQ6q0ADCEOqOgxuww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=skSZMJCxx5hkdKhii/CR8+Hb56esOFV3bhF6MfbbNWk=;
 b=Cvtdvgv+4JvHx5+DgwUv+0AbQ03VB16pgcjq7dVJhqkhGBiqSIG4XFDBudj28y9TTIwtmUZR+WYqAFe/43Rkx9ijHTiEnPQD1K6OTGG6sQmd+rjjmuFH3sQgda0FnyKh2Eq5e/S2TM6lO9XzHinx7KSGBeJL+kDMViq5LEKjnYKDQq7CypGKTDz1+cdKAGq0kQTUKWXbcqeMzxCWtlai2ihBsw6HS1iz7cLNBibyfwvsZsEK272UM61PuTnA5hUG6jbZ1F9fzIPDT/MOe6JKG6zkv787zHBxwLNQcHtrKeTCWgRk5/vCHfDzsOwAiPSJpqKupQ6EKClurVAzyQNI0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skSZMJCxx5hkdKhii/CR8+Hb56esOFV3bhF6MfbbNWk=;
 b=uQVXA4ZPv1GD/4HvsVpUy2HEyMvmowkDxhAdyjam+XINl5GibTrTCPBBiT+BVw9tZ+oTDDAnp8qCjkqmctCHBBS/sScz3tlG52fNBvJ05VCKRg+EDLIwzBN4DqwTEyYuRjbZXO7kHhBHnUuXG9hYVkSSHewfGDXAfMisZRtx7pW/8QhUxRmXkCzS/iIXaWNsFTHxaXPyVKvb6eXa8ZJBTw4Ud/TQt5pgT8f8pQSohTjKiRWvLIykzyJsyt5fhwRh5UG8Fbu9sd1zOW3IcdFGEnSPhvP6IZ/g0sjeE6FpomKgOJaVv/VLgIjBmyXAfJE05GMrNi5MvsWIm6J+6FB2rA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CY5PR12MB6600.namprd12.prod.outlook.com
 (2603:10b6:930:40::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 22:18:33 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 22:18:33 +0000
Date: Thu, 10 Sep 2026 19:18:32 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Matlack <dmatlack@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Logan Odell <loganodell@google.com>, arnd@arndb.de,
	pasha.tatashin@soleen.com, rppt@kernel.org, pratyush@kernel.org,
	graf@amazon.com, akpm@linux-foundation.org, pbonzini@redhat.com,
	maz@kernel.org, oupton@kernel.org, bhelgaas@google.com,
	alex@shazbot.org, kevin.tian@intel.com, dwmw2@infradead.org,
	baolu.lu@linux.intel.com, joro@8bytes.org, will@kernel.org,
	robin.murphy@arm.com, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, iommu@lists.linux.dev
Subject: Re: [RFC PATCH 0/3] liveupdate: Move to feature flags for LUO and
 memfd ABI compatibility
Message-ID: <20260910221832.GH3968357@nvidia.com>
References: <20260903023452.721732-1-loganodell@google.com>
 <20260904160009.GV4157646@nvidia.com>
 <aptFFYqcSiBdMLE8@google.com>
 <20260905012403.GX4157646@nvidia.com>
 <aqIAtOoew-_6jw29@google.com>
 <20260910143448.GD3968357@nvidia.com>
 <aqLOWkuVKccR-I7W@google.com>
 <20260910171210.GF3968357@nvidia.com>
 <aqMgjXfTJ8u3n7Kj@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqMgjXfTJ8u3n7Kj@google.com>
X-ClientProxiedBy: YT4PR01CA0436.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::8) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CY5PR12MB6600:EE_
X-MS-Office365-Filtering-Correlation-Id: a15d49df-9717-4f83-750c-08df0f897359
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|6133799003|22082099003|18002099003|4143699003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	1MrG7hkEr3/b3LgVUbr3162uj/00KXpgrem1FS0xbTzLzM3PogRZ6ft/V8vIiKXJ8OVtbi8DxkFKxmamRPOP1w6Fn11gb+rXacwmsSNNjmV4uPfLWIkPPTgyGyWvnRqHiyS6Uq2oagzDuU0sdraG+aYdtLYfQS/MUop0XfL5UXF24KveLIiOMxnOnnew2Ld8F8mww4OGPrqAOIGVi1A63zX4HXmE4CRpg+JGsp9KYXvYreTHuUyeBZZ7qHttNIqwgnFOAjmX0gwDzKNha+KwrLEapgcYx3On8gjDmS6D5Paceyzov5QAIwWosma0dZbfzi473LfDrgIlQS3t2QSkMAYi6X52XKYi26SZp+SBo7SN9IrORW8zbVgxTpr4opfnq+U00wxEG8mNKkOhUr3HQ6YpZKrBAPTuAl8m4eQvoKcvGGWO6R6CAhw+vK9bIHdAYQHOSLKI+q63cG4YxysIOUwbtMb2uGzG+M8hESfeEa6dfI3ywOMIIUV3idfV1GmtrRRhvKUu2o5XkmOHN6C13Hnw62pVS0fkEbO/9BvACzmd2Aajrf4UkwJs+1iVJ6PvSyWXiPMBsD1YmrP0yY3R552muNiaaxkcxGeXYSeK7KGXhZZr9E/Ahy40Nfh39DFzC1j9T5eciGxPqzmdz5FPoc1BRAXkuQ49f0/oh42TpJ4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(6133799003)(22082099003)(18002099003)(4143699003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DDe9Xc7gGk3KAGlAubroCNFNm8Bxdjzpg13Pguni19iU70Qbi5dn10yABek7?=
 =?us-ascii?Q?+BbPvjPhOkMMWVPW4ZATvYezSPIri5b1bMC0hkGPf8h+WGU7HXfoNQxpuTtL?=
 =?us-ascii?Q?v6jo90Cgt+p/9c95391WcvrsWRT9cKvgBP7UgNm83M17W1S9gyJEC5cnf4nK?=
 =?us-ascii?Q?giVW2PkEkYA8gwcSBPrNjI0yMN5kvvJwOC73Prt63j+qPnqSkXwvhIf0XG0l?=
 =?us-ascii?Q?rOvHNTF2KSVZMTpp31V2oEWOpy9hTNTgDPtXgkSu0wd0E7M6A3U4hhGtxkxV?=
 =?us-ascii?Q?W4RLjl2WTGQjCe+wEBEF3KkBVbSt4oPITguHm9V1Qr1VzcCfWcsXZrKDmCV9?=
 =?us-ascii?Q?bUp13/PyjWNpWh9MxpElG+BExyyiNOJdUA89xBYH+TYCkPRrb0IB66RwWFIZ?=
 =?us-ascii?Q?PIBrstGRpT2i6K5Eq5sQWNhpqVtImaoig8Noc/wouZqb07XpdC/9M+XU/3vo?=
 =?us-ascii?Q?XrGyYeUth4pM775w8j94D9z2PA2bczU+GF1dSsklciTEkPmOzGz2pplgVHl2?=
 =?us-ascii?Q?lctyduI7G81zuOIJFcej/OoV1VS+a7CYPRL8F4NQW1mkyaeh/7iaTjBUFF2J?=
 =?us-ascii?Q?W0ba4k+kkkEQxfWz4K37Ht+eN6H23hsKNfSaL8FaqV6qV9E94kqmgyOBzLZH?=
 =?us-ascii?Q?NUJer5Z2h7b+HAcr3XmwYqvNIUqKHiY+l8jxicwcIH/6WNcdNKedqLQuW8ND?=
 =?us-ascii?Q?FGzaPt0V4kKXdUO7pUzZDAKQ9PUX+oVrr6S4b539Cs4eiVklioZZd4BgRmBH?=
 =?us-ascii?Q?ehaX2PKmQoS6a1Nw6bGlp5o4OGwslD4GuOtk6LiFtA6St3KLZb0UFtUczR9L?=
 =?us-ascii?Q?0jCLTMbZYtniOqDvRf7HR3KJkxNepSGS1VcNgi5/Ia5CSnKbOrpEAL2kBPGG?=
 =?us-ascii?Q?MbVGtbt12vuPRmSERGI+O/SIwydjWDnOLkrRJyaN3HjoeKb7PFnLX8as2GEF?=
 =?us-ascii?Q?N5504hHIsB2foJ/XgyvYTjlmWFQQLkBoUAbsOxi6OGIJh6++uLJ2UN8sYJSv?=
 =?us-ascii?Q?fZjS1gUPe/PWiGwXnhKsuWAFhnakOZz82LkBQU/0RtIipjJ0UZI6WCG2TqER?=
 =?us-ascii?Q?NnG0CH7Bk5w2/6Ju5CRi+dnwG4ZjjWJVm9NHp0+nvfdY+29YY0a99LJ1U1uv?=
 =?us-ascii?Q?G1ZmDpBNZSz60SHyCgtA8Osum/ORpMVzoqGWQcc/UET12xV4Tvyx0cxNVgTM?=
 =?us-ascii?Q?G1ATxp++dwtYMBQ74GCi0BltsFUg2hpkEGBB70uFuFZJFTYIQiL2R73gIEF4?=
 =?us-ascii?Q?OLxojJrXfZ9/cUJ1PWMA+JlY76t5DkxqIAg111fZRHciNTMWdWhIviT/WDvr?=
 =?us-ascii?Q?zpgnKnaJBP2Eu+MVC1iOTjMN6JUDWO5lSdj2+p4Z3FT1JHQj+SstEmesPhdt?=
 =?us-ascii?Q?CAv2TJhvRTdeTOv7wnTFMjj2BPRh6AbZ2uo5Rn83Krwppf3XGYy8hqz7gykH?=
 =?us-ascii?Q?KJk4AStKO7CPyunikXj5Iu1R9eXnLLMaKffBtvZqXG1yEWsrsJV3VzuGBCbt?=
 =?us-ascii?Q?CvIOec1brUcK6y+VMfbI0skRfx+3RuJ1hu1Faft45fFurHsjNuolQcuHK47F?=
 =?us-ascii?Q?9yNnfLrCiyX0aSE0OrMV0CR+0NDO+c1nzV/9WuwwXvUFQ53fe9jdvzEmgft2?=
 =?us-ascii?Q?YpUZ9XdERVYz27Df/ctIDIdt/5wRvZeXvZEYIO/mJF2vyqjUMVfcVmOZcZgO?=
 =?us-ascii?Q?EUu0IlYo3vyULrlddYZWuDKOBc2pvvHJJNlblcOX8O6NWJv0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a15d49df-9717-4f83-750c-08df0f897359
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 22:18:33.0913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tOcwI9WOc7rme2P/95uDNbTYQSUUGV512F92iOcPIekgiYmCZsrw0oFwfPO86YQY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6600

On Thu, Sep 10, 2026 at 09:27:58PM +0000, David Matlack wrote:
> Each ABI is now extensible with a set of structured featured flags that
> are exposed to userspace. Userspace can inspect the flags that the
> kernel supports and confirm the next kernel also supports them.

I'm fine with that bit, it is really just a different way to encode an
ABI ID #. If ABI 5 is spelled b11111 instead it doesn't materially
change how things work.

It was always the case you can use the same struct extension techinque
with a version number. A version can't handle 'holes' in the feature
mask, but I haven't thought that was a meaningful use case.

"if (id > 10)" instead "if (id & FEAT)" isn't a big coding difference.

My concern is the implied position that the kernel must make full use
of this to maximize compatability or bust. That's what has always
concerned me about all these proposals since the start.

I do not want to have arguments upstream about not changing things
because we didn't do a perfect job preserving luo compatability with
upgrade and downgrade for arbitary kernel versions. That has always
been my position and worry.

So, change the simple version to a u64 features[] tuple (be sure to
use an array, we will need alot of them!!) and I'm fine. But I'm not
going to promise that every upstream kernel will strictly only have an
increasing string of 1's. You are going to get some that look like
b1110000 and still wont work with old kernels.

Sean's initial email was asking for strict never-break ABI
compatability rules on top, and that is what I've been reacting to.

Jason
