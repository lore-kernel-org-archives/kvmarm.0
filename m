Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEDA33A01D
	for <kvmarm@lists.linux.dev>; Mon,  1 Sep 2025 13:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.176.194.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756734862; cv=none; b=ZPMDeXoAnIgiB6lMqjxk/eMqzaU11tnsuA8Cbnz08wye4UgzJc87ciJdNoQZ+AJflK1zkHiNgsvlmNRwxrOM3SVZ7kYntAJ5fv3QehkdoenF5N59whhT5yArGUM5iwAvGaXWSc2JNybSoD74Ig9bgJJfz2v7Qzmz/8Cid4Y85to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756734862; c=relaxed/simple;
	bh=6VorQX2phyRDqlOgHM/mTP8lllqO/aVw796zYul7Z28=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rcHsD5GIVZr6ZRgtdU8TiYEn07i1gBC+3UQNHikMwShEvonz+55blrRSBoD9FlMwysyHACdoh4m+ckqil1TZg2Z5dJ14/wbHi/pXw7uNDzzFrhxg/isSc9zshfNqJi96RSRvgo8wpSjoEonXNGPXUsjMIHXOrMyK3v+tO/E2DMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=L6qa3VBg; arc=none smtp.client-ip=63.176.194.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="L6qa3VBg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756734860; x=1788270860;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8FXGRJshnSKv4swI9rc/O7cu1N6KjNCj8MEEMoNffZ4=;
  b=L6qa3VBgGo4Wrug0eZbuFet7BrbBylLadR5+sL0N+EQgb57sSVE7H9Nb
   5eB1+7p6nTBpwXClbMFrolnfsDhm+98hlcXvLW6PlO2gd2tuK1IxaWdUk
   /tQjNjksCD7LL35qcGv7ZebbqxBxX1PvNiekWwppPRYWgT+fCMh1k/W6p
   QoChBxJ4SgYjPPhPtebaMR0Eyx7C+0ygcdbkBUhAqss3D/Sx/QrKpkj3r
   liErEDWv9BgVDQGYZVsqZCarB2MmmQ/Y1q6oODiCPJt7e+Nh79YLIXWi0
   WqK738bl09/dHok6gfjy6uhmHy+c6/h/Kv0zkXZ3oq1YIdPpIeH+yr+UE
   w==;
X-CSE-ConnectionGUID: gggXs4BvTVmSlkjjgWje9g==
X-CSE-MsgGUID: ND6y5eCkQmyPHrPmUhHHJA==
X-IronPort-AV: E=Sophos;i="6.18,214,1751241600"; 
   d="scan'208";a="1463813"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 13:54:11 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:18474]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.3.140:2525] with esmtp (Farcaster)
 id 6c2ba49e-6c86-45f6-b459-405011a28a46; Mon, 1 Sep 2025 13:54:10 +0000 (UTC)
X-Farcaster-Flow-ID: 6c2ba49e-6c86-45f6-b459-405011a28a46
Received: from EX19D015EUB001.ant.amazon.com (10.252.51.114) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Mon, 1 Sep 2025 13:54:10 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB001.ant.amazon.com (10.252.51.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 1 Sep 2025 13:54:10 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Mon, 1 Sep 2025 13:54:10 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "tabba@google.com" <tabba@google.com>
CC: "ackerleytng@google.com" <ackerleytng@google.com>, "david@redhat.com"
	<david@redhat.com>, "Manwaring, Derek" <derekmn@amazon.com>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Roy, Patrick"
	<roypat@amazon.co.uk>, "rppt@kernel.org" <rppt@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"will@kernel.org" <will@kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>
Subject: Re: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
Thread-Topic: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
Thread-Index: AQHcG0fkqK4jccjXtUKv/NLtaS3P1g==
Date: Mon, 1 Sep 2025 13:54:10 +0000
Message-ID: <20250901135408.5965-1-roypat@amazon.co.uk>
References: <CA+EHjTxOmDJkwjSvAUr2O4yqEkyqeQ=_p3E5Uj5yQrPW7Qz_HA@mail.gmail.com>
In-Reply-To: <CA+EHjTxOmDJkwjSvAUr2O4yqEkyqeQ=_p3E5Uj5yQrPW7Qz_HA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

=0A=
Hi Fuad!=0A=
=0A=
On Thu, 2025-08-28 at 11:21 +0100, Fuad Tabba wrote:=0A=
> Hi Patrick,=0A=
> =0A=
> On Thu, 28 Aug 2025 at 10:39, Roy, Patrick <roypat@amazon.co.uk> wrote:=
=0A=
>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h=0A=
>> index 12a12dae727d..b52b28ae4636 100644=0A=
>> --- a/include/linux/pagemap.h=0A=
>> +++ b/include/linux/pagemap.h=0A=
>> @@ -211,6 +211,7 @@ enum mapping_flags {=0A=
>>                                    folio contents */=0A=
>>         AS_INACCESSIBLE =3D 8,    /* Do not attempt direct R/W access to=
 the mapping */=0A=
>>         AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM =3D 9,=0A=
>> +       AS_NO_DIRECT_MAP =3D 10,  /* Folios in the mapping are not in th=
e direct map */=0A=
>>         /* Bits 16-25 are used for FOLIO_ORDER */=0A=
>>         AS_FOLIO_ORDER_BITS =3D 5,=0A=
>>         AS_FOLIO_ORDER_MIN =3D 16,=0A=
>> @@ -346,6 +347,21 @@ static inline bool mapping_writeback_may_deadlock_o=
n_reclaim(struct address_spac=0A=
>>         return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->=
flags);=0A=
>>  }=0A=
>>=0A=
>> +static inline void mapping_set_no_direct_map(struct address_space *mapp=
ing)=0A=
>> +{=0A=
>> +       set_bit(AS_NO_DIRECT_MAP, &mapping->flags);=0A=
>> +}=0A=
>> +=0A=
>> +static inline bool mapping_no_direct_map(struct address_space *mapping)=
=0A=
>> +{=0A=
>> +       return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);=0A=
>> +}=0A=
>> +=0A=
>> +static inline bool vma_is_no_direct_map(const struct vm_area_struct *vm=
a)=0A=
>> +{=0A=
>> +       return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_map=
ping);=0A=
>> +}=0A=
>> +=0A=
> Any reason vma is const whereas mapping in the function that it calls=0A=
> (defined above it) isn't?=0A=
=0A=
Ah, I cannot say that that was a conscious decision, but rather an artifact=
 of=0A=
the code that I looked at for reference when writing these two simply did i=
t=0A=
this way.  Are you saying both should be const, or neither (in my mind, bot=
h=0A=
could be const, but the mapping_*() family of functions further up in this =
file=0A=
dont take const arguments, so I'm a bit unsure now)?=0A=
=0A=
> Cheers,=0A=
> /fuad=0A=
=0A=
Best,=0A=
Patrick=0A=
