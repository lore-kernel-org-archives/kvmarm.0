Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB63014A83
	for <kvmarm@lists.linux.dev>; Wed,  7 Jun 2023 16:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686155947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bOcvviShinbhn2iyRTvdKZK8HLEy40XQ9M2bpHgU45Q=;
	b=gjBn2ensYFahZDjIfh9u2v3N2jSnyvXwtVQ0bx5HOyxDt42h9VRu1e0nAvvgblkL/mGtMU
	6N8XakvHRn8mCYvRD60WMCdt6JAT1SOic6PN6NP+9SZGwK5I2x03K1FMjCfhjj9j3Hbuha
	LS/sQMx1nmrZrn+bljTy+XYrQxN/wBQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-nudyrFJgMWKKRgi-zl17Ig-1; Wed, 07 Jun 2023 12:39:05 -0400
X-MC-Unique: nudyrFJgMWKKRgi-zl17Ig-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f7e8c24a92so11238425e9.0
        for <kvmarm@lists.linux.dev>; Wed, 07 Jun 2023 09:39:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686155944; x=1688747944;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bOcvviShinbhn2iyRTvdKZK8HLEy40XQ9M2bpHgU45Q=;
        b=c+F7PUs+3uBy7piHwKAopKaDAq+ZEcip86UAIpaUzShM6EovDvVMII88V5HwYQyz5L
         BvjkT2l7PV3fCzUp5UaTt6X9OshOBeHczeTDiuD+scaxtunWy+M8H+WBAUGR9zuRO0c7
         rhq0Ag027RHXhnbj3sxMq1x5EsrBPXrvjlsVbTv6A4cmDf7KyqgN2RfZemgNjZf6Dh8+
         uJT+E6YPWrsToRro17iPVimAqGBTmJh2uxJoeWZQ72Yamq1mDJXc8ZxpRfze2uxkj5/C
         gfdoGnNb6p/gV4NK5ulfP6kB+npdY7AUY7UHUaCS5XJAGDU3e2+DS0ig8A1sivLvIeRJ
         6rkA==
X-Gm-Message-State: AC+VfDzMZJcukhU/lYDrETWbQJoQvEpZYjHL3TkFH6T2TGOBeNaQfv/P
	pxVm5niAh63WqQBCvX8cejghWh5dCdjExLNfmI03rKBv6agGKBnlVy6IfvJZBZA5m9j1dzpUnCu
	dZtBpaHiPyHmdMl3Q
X-Received: by 2002:a05:600c:114a:b0:3f7:16ed:4cb2 with SMTP id z10-20020a05600c114a00b003f716ed4cb2mr5620759wmz.13.1686155944171;
        Wed, 07 Jun 2023 09:39:04 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7WBuAgdTAHzkQGoCsOTR8t1SjS/VoQLtoGVsbhT1+t9UytMVWEJy2RRG5ZlXj6lnXkQIGKMQ==
X-Received: by 2002:a05:600c:114a:b0:3f7:16ed:4cb2 with SMTP id z10-20020a05600c114a00b003f716ed4cb2mr5620733wmz.13.1686155943854;
        Wed, 07 Jun 2023 09:39:03 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id g9-20020a7bc4c9000000b003f6129d2e30sm2733104wmk.1.2023.06.07.09.39.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 09:39:03 -0700 (PDT)
Message-ID: <cb0870e8-c4b5-7d60-89e0-2e0cd2194ccd@redhat.com>
Date: Wed, 7 Jun 2023 18:39:01 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v10 00/59] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Jintack Lim <jintack@cs.columbia.edu>,
 Russell King <rmk+kernel@armlinux.org.uk>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20230515173103.1017669-1-maz@kernel.org>
 <16d9fda4-3ead-7d5e-9f54-ef29fbd932ac@redhat.com>
 <87zg64nhqh.wl-maz@kernel.org>
 <d0b77823-c04c-4ee0-cb55-2cc20a48903b@redhat.com>
 <86r0rfkpwd.wl-maz@kernel.org>
 <bdcf630c-b6a7-0649-8419-15f98f6b1a0c@redhat.com>
 <87mt1co8ne.wl-maz@kernel.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <87mt1co8ne.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 6/6/23 18:30, Marc Zyngier wrote:
> On Tue, 06 Jun 2023 10:33:27 +0100,
> Eric Auger <eauger@redhat.com> wrote:
>>
>>> By the way, what are you using as your VMM? I'd really like to
>>> reproduce your setup.
>> Sorry I missed your reply. I am using libvirt + qemu (feat Miguel's RFC)
>> and fedora L1 guest.
> 
> OK, so that's *very* different for what I'm using, which is good! Do
> you have a QEMU branch somewhere?

here it is:
https://github.com/eauger/qemu/tree/nv_rfc_rebase
> 
>> Thanks to your fix, this boots fine. But at the moment it does not
>> reboot and hangs in edk2 I think. Unfortunately this time I have no
>> trace on host :-( While looking at your series I will add some traces.
> 
> I've been able to run EDK2 compiled for kvmtool with only a couple of
> change (such as using SMCs instead of HVCs, and disabling the broken
> DT-to-ACPI convertion). However, reboot isn't something I've played
> with, as kvmtool doesn't even try to reboot the guest (reboot is
> handled as power-off).
> 
> I'm pretty sure this is related to tearing down the shadow S2 MMU
> contexts when QEMU reinit the vcpus, and we may fail to clean things
> up.


> 
> I'll try and have a look once I'm back from holiday (and we can have a
> look at KVM Forum).

I won't be there this year. But enjoy the event and enjoy your vacation!

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 

