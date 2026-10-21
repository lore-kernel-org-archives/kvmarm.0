Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=40.107.200.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792604414;
	b=ZRhSIrdFO3CdLQ2+fRqZvGiU0v9QhyMyTuMxlx0rCN0wpQYPh2NjcKixH1/kmflIcaf1
	 2iMIm01z8vV/s7E44GXj4nUVmRvgGNmVwrE2gCaZ8TdW62SyvwHN/wQkm8mZNqUMcWICs
	 sLMZQAaI2Aw5PHFBy8NAbYgffNKJ37B9I3aw21R3hrROKqmQoQAaD1hOXUxb9FaQI6LNK
	 1HIEF9DuGodPo/o+JoX45xqA3/SxdJRgXxitQxW6C4B+WdGKFKdnABAZx1xER9SP7IRjK
	 xeEPa02G2d2yBwCJHnjg17MWqgIIdtdrZ+kBvhHlMz3nB/o0jL/S+v/H1ouPD7T+nDA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792604414;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=Sh+BLdyawyu3x2WuC9w4sgPwmZXii/nWDIS0NOhyN2k=;
	b=L9kObu2Qs7qwUJnh+GXjAw00t3akWJBkQnM9qFEpgKN85uM3xHXyhjgOazop+V4f4Uoj
	 mlnAPSPu5fqas7r/tCmOPgARuHIkdp8EJS3eBlc5qfP2F5jsy2tULMPsaD7g+8+mcs09N
	 b/bNJ+hejoSPb4bOoqlRoqfkMXFknIEudfikBJWRjdbUIusruj59ZIEDcj0HJaDGuJG2O
	 gENU9lj56C5+t8+LkMO2N/WFDYfK1HEItjizKvj0AeK8D4JrYV6ygIzlq46sJHcAU2Mue
	 pSGGJDE3wmdQGjhnoPxfjPRf+ZqYWlD1AsNovlp7D9krKtyD6bGzIBoOZiAM8HoJJTg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gBUv3QkW;
	arc=fail smtp.remote-ip=40.107.200.50
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012050.outbound.protection.outlook.com [40.107.200.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36898606A31D;
	Wed, 21 Oct 2026 17:40:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36898606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gBUv3QkW
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k9HHKtENJG4+K2Rtawv6hGS2wcmr3NLX3/PslEZ62cpUbv+bGBj3/c92WBpYFRXWIO2qdt/ET2KujvOOwnrdBP/KqXA/ZYUaJxcNi8OEysWSDo+YE9cnmjXotbRkZuK+o8gy/E4s6/TwmGJDmTpGkSVzkGAnuDABgkpFevV4/0r6ju5Wk7E72Z3qA+fF/egWdQqb8A5I1Vrjr81F9eB5fL565+BttFWwP/I4M0Ldqh6i54Z9nqxcNDStHRu8PPj6Z9bKblLpUtpIc7jbvPGi5nh2VjCHzFfr3dhSSHGmU/ZM1aqrv8twI7SkxpqUqDgUrjAyqAeIf1DNJKAqKa+Rjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sh+BLdyawyu3x2WuC9w4sgPwmZXii/nWDIS0NOhyN2k=;
 b=wt248RjEHiIkbQhssKKM5/K7Vfe1tUo5iDO5YAKRtGUBV34YebQo+7iIqaAmYQvrabayQbGLTzNTEPu8WJSGPjZJzGAdBDvDiURPbwMFEaBxikHiDeA83zp+HJC4RnP0AkPNVrIyASrCWqlTaivr4dVLd42/zetcV8leD+rh95vJm1+GAC12RkR3S7z3J9jo+5HV7DNRfIpLLmO1Z9bwaBG5t2OWnR/2T2awVvfpfsfrxKxJPPkvnQzcbPs0fc0bJDZXGrE/AovCuGT0W7jUEgcH06n+iQeBeEYIOQYgQDDeBXSRyQd1toFI458eQgl+iE9SvUKrLvtGWzDpfT927g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sh+BLdyawyu3x2WuC9w4sgPwmZXii/nWDIS0NOhyN2k=;
 b=gBUv3QkWQY0wBPHaMuiCTJfpTge3T5nYTtyCosjuaD63aaMZAOeKWK+lE7wlKNsuw+Ks+Sp/HNrQkLRJbH3yirIO8FX1bNNmcsaDGFh8cy3d2fWS4CQmFjM6vir67JGEfrBp+34FSgexMniCcoySSmhU/D3GraABO8F8uPQDfiC5SsXsDiPmCG0WEdYYUBAqEdODDECrLRpifMkPcxqVx4fZbaOt+ooiWywwbMpX6papLdnzxi2HXIEsPpPjob8OOfJnv68H1pp+S/ZhZP7ploJvf0wZNtabZHVOKgeGCjRQa8ga8dOeIHyhIeQ9FgJ4HhrYRllRNaoSozgDUOkk7A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH8PR12MB7375.namprd12.prod.outlook.com
 (2603:10b6:510:215::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 17:40:07 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.012; Wed, 21 Oct 2026
 17:40:07 +0000
Date: Wed, 21 Oct 2026 14:40:06 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Tarun Sahu <tarunsahu@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de,
	David Matlack <dmatlack@google.com>, robin.murphy@arm.com,
	loganodell@google.com, oupton@kernel.org, kevin.tian@intel.com,
	alex@shazbot.org, dwmw2@infradead.org, pbonzini@redhat.com,
	seanjc@google.com, will@kernel.org,
	Alexander Graf <graf@amazon.com>,
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev, linux-pci@vger.kernel.org,
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
Message-ID: <20261021174006.GU3008132@nvidia.com>
References: <20261021152527.375070-1-tarunsahu@google.com>
 <20261021152527.375070-4-tarunsahu@google.com>
 <CA+CK2bAQbmq3ArP3XMErF_8RC2CUwvgpLY0H83D0nCJTaVKYyA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bAQbmq3ArP3XMErF_8RC2CUwvgpLY0H83D0nCJTaVKYyA@mail.gmail.com>
X-ClientProxiedBy: BN0PR02CA0051.namprd02.prod.outlook.com
 (2603:10b6:408:e5::26) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH8PR12MB7375:EE_
X-MS-Office365-Filtering-Correlation-Id: 0da19133-30cd-4aec-e6eb-08df2f9a58dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|18002099003|10067099003|22082099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	//Zveg7enEZjDC1odBo483/ecevc1uWMM/arC+UNUM1pW8mwHaLeIHpSa/T6IaFdUOWbx4pcfBk81LSSXOfcLo8V6vLWB8r44QQgSD67qmFdgoHI7aUwTkzjMGb/e9SGoNLYWHEw0NOcQIVp08zf3UtxUDsb/FGzFp4z299SSPu0iAa5tnU/1CAq+MqtHU/Iw0V4i1NvqNunASMq4PR8SEhaP6JK6hENH7P8jYt5tDfv2OxyhRTaRWPDy2By+Pv6IRBAt4IeQQnTq92i28hV0jctpJ7HEvrYYaKBp30y+LXmWBYjzM6Te5Cz4kSro4EOBnYxipKeWsP+YtNEAsJI8vhp4zsCb0Jz4H6KOHCz9QqCgOdK0zLHBf6wmFv6CYmzWKpwnx9Sgd4fLekcXTc1zfWGTebdRbZyDAO+rfoTeckn4UdUpXbDFyHKwlj/agfunYrMaYvkMX2RPxsynIAkSdR9qDryJiahCmINAiHYA6ErrkVr0oonCa7llCRl8wGpnwlJmIzSunCryePNFzGbuIvBdmLDht3CqdAomJwYguCKUV0yxjvNgqinvZfSVvYEX5SfEkRlKMnBCFKh2MFuiaVVhdfvQ199WCSFDkZVLqkKheEcbyb4HVzk/hclM8W8IqbGisJILv5z83ylzdhL7LsLYJ4uwRgVeCoaSxyr/fo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(18002099003)(10067099003)(22082099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S3QwM0xIQ1g0cEtSay9pZWEwSnlZd1M2Z2d2RUhYZzlubTc5dmovVnF5cldl?=
 =?utf-8?B?cGNwWjg1ZkJtSEViQXlQbHFzY29VNC8wSTlTSU9ObHRYY1ltUFZ3ZlVkc2dG?=
 =?utf-8?B?NGxjdEx0K1pDSVV0UWwzV2dvNUtYWHlzTEZXd3Y3WlFGUGlHb3Q3SkFVaWNx?=
 =?utf-8?B?WEEzcTFPSlVKd0JlcUJoYjc5eHVBa2xFWHU1ZStCd2ZqTzN0STdYOGlFNHM4?=
 =?utf-8?B?K2FMQnlRdk5YUFhzL1EwUWEwNUVwZ1IzQXhROGs1K2ZLT3ZxT2szai92VVdV?=
 =?utf-8?B?MytLcm96bENxL2U1TUtEM2hSdmE4NWh0M0NoK3NYclFVbm1xeWgrMXZ6STJK?=
 =?utf-8?B?TzVGTTc0bjJ6Y2loZ2Q0Tms2RytWamt5Z2NweUNWbDdtOHExUi8xclphaldG?=
 =?utf-8?B?VXhmWEs1RE5ESkxzM3doRWw4V29MZWJ5bnZOV2lBZFA4OU5YUjRwcGdjOVcv?=
 =?utf-8?B?dWNJOXIyaTMzWXpyY2JzSCtDUDU0a3NrRDFaMHVWclV3aEtoeHl3TGJDNXlV?=
 =?utf-8?B?aUIwWWlCWThKci90OEp3NWZFRWZvU0d2QTN3YStvc0NaK2JrY2xwRlpzcGc5?=
 =?utf-8?B?SWtaSTVuRDZ4cFRLZldaTklRRnNxYmxjZnpubXI5aXZ4cGhLK1RMQUhnZ0pV?=
 =?utf-8?B?b0hNL1VGUm9CcVRGUS9iUGNsaUpoaWVvK0lzZlZsNzZmaGN3cEJzb1RXVjdH?=
 =?utf-8?B?YUlkcHlzWGk2REg2MnJxOFBsT1NkWDFlSTh4a2NSMnk3OVgrUWVuczlEbUtV?=
 =?utf-8?B?MGpYcjg2ZEl1SFY2b0lkMFNmekJBTE9vRFJwMXJYK2swK1R0dXluOGdpLzJz?=
 =?utf-8?B?a09Cc0FwN3F0NkZKb1paWjZ0bFlaOXVmNnU3eDFNRHQyYkhjOTNSN2l6TUxo?=
 =?utf-8?B?cGdacjdWVGRsZ3p2YXlFMSt3dGpqQmtmSXBHQzR4czVCZnJRRkp3dFp3dDZt?=
 =?utf-8?B?bFQ5Mnc4bGE0WXBxZHV4TFNycTZIM1RKQzQvVUtpU1ZrSmlTRmc5Z1pzeCtT?=
 =?utf-8?B?Y3Z6bXc3MUt1cEZoYVd2Y0hTdmwwVCtDQ3k2VS9CdFEzTXV4M0p6WlVObzB1?=
 =?utf-8?B?aUVMdjhtL2l0ME5xbHgzMnkzeWVZRlovekxQK0k3ZXVKTGNOYTJXTUg0WnNt?=
 =?utf-8?B?Vml4ZWxUOUMrQWVtS3JoYXpGSk5KM0hxOG1RNkEzQmt5bS9ZUFN0akxZS1JZ?=
 =?utf-8?B?d2o0ZGcwYzQ0eEhFbkczSjg4S0MzVXB0SEVGczh5dkJRL2FiSlU0WTVZblJK?=
 =?utf-8?B?bzByLzA5Yy9kNVkwYjJoQVF4bXMvV0ZhVE5IVWxnd0dabFlaUy82cEVPS2pu?=
 =?utf-8?B?WGpLTDU5K01uM1p5Q05lcEFrRVovSHpqNDdaYTloeTNJSHhxKzdZaEZvMitJ?=
 =?utf-8?B?Tjg2M0dVYyt4SWZYcGN5a3IraDlxR3pTQTgvdG16RlAvSU5WSFVGWWxVVnJx?=
 =?utf-8?B?NGpDL0dmZkU3MVFVYUVjbEZGKzk1WXlPdzFxNFZSMGkrZVhxVlBOQ3B6OHRI?=
 =?utf-8?B?cmVPbFk3ZlNUdll1a3g0ZW9OdjNPdXRLaEQvUTBFNWtvVVVQSWpiS2ozUXRo?=
 =?utf-8?B?a1RhNGZXU2NKSHh1Yk53UnZsQlVOYnl3bDhSMmVaSG5rRDU0S2xVY2JqNk1E?=
 =?utf-8?B?ODNEYVRXTnFWWC9OdU5talFpOURJVm1SMTZxU0VZRytUc0dnd0M4VWdoSTB3?=
 =?utf-8?B?SUFvMmZSUWgrOExKd05SeDh4UGl2V0dqWFF4N1M5T1ltWk44U1U0YkdhVmhj?=
 =?utf-8?B?bVd1NmF1ZENqQkZMWWZxcTBncnI4RVNSaXd3K2V3WFA1Z0paak5JNEpvaWhp?=
 =?utf-8?B?RlR2cXQ1VjZhaFNIUy9WSEJlSTJrNWZqdUhvbDlKTFZ6c0tCSnN2N1NNdXhn?=
 =?utf-8?B?a1JCb3U1WDN2VTlHOC9qK05uUkVhc3ZUNHVhVzdLcHRRQ0NzMm1KbjNkYlR0?=
 =?utf-8?B?d0Z3NlJ4TGRSalRwMnQ1S3pMN2NQazIzQ2N3V3ZlRmRndXNRNXhkeTRYWFRB?=
 =?utf-8?B?TlRQdGpJVGpDdzQvcXhnSjd1QjlkRS81VTBiSmY2d3UvMjhjUzN4VDFjeTdn?=
 =?utf-8?B?dkx3eFVka2xUWCtYMGVreUdmek1lV05XalpNMDQ0NWorTDhDRzhuUit4TFhU?=
 =?utf-8?B?V1VKTVZLZnZ3eFpFbHcvYTNpYkc1QmVXbVhZZnQwbUVGRGdLYmJmYjhINUpi?=
 =?utf-8?B?d2JCcURlWksrazlRdHVJSllnSWY4SzNuRE1Qekp5bGRQS0w2ZmlQd1R3ZWhW?=
 =?utf-8?B?d213OWZ0SWpDQTc2RFZZdUdPT0I4VG9NNnBXVUJiMkwvck5hVlkyL3I3NEVN?=
 =?utf-8?Q?p/X4sLqUr2pBiB1mfb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0da19133-30cd-4aec-e6eb-08df2f9a58dc
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 17:40:07.3422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 794ZxyqdEjLv0iivdjt47az1uT9Z2XsAePZvyGVDFO6Lfz9QPB0c7U1IZHywYA9q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7375

On Wed, Oct 21, 2026 at 01:27:22PM -0400, Pasha Tatashin wrote:
> On Wed, Oct 21, 2026 at 11:25 AM Tarun Sahu <tarunsahu@google.com> wrote:
> >
> > LUO and its file handlers validate handed-over state with monolithic
> > compatibility strings ("luo-v5", "memfd-v2"). Any change to a serialized
> > structure, even an optional additive one, must bump the string, which
> > breaks live update between adjacent kernels. Replace the string in
> > struct luo_ser with a feature header, so that the target kernel can
> > accept or reject the source kernel state per feature.
> >
> > struct luo_feature_hdr is a fixed 128-byte header: the serialized
> 
> This patch is all wrong; 128 bytes is far too large. For every _ser
> struct, we only need 8 bytes instead.
> 
> The first 4 bytes are the size, and the next 4 bytes are flags (i.e.,
> 30 feature flags + 2 reserved bits for flags extension). The last two
> bits of the flags indicate whether an extended flags field is present.
> Each extended flags field is 8 bytes, and its last two bits indicate
> that yet another extended flags field follows.

I thought we agreed not to loose the string too, it was a tree
 string -> feature flags -> individual values

The string is the emergency if we really badly mess it up.

Jason
