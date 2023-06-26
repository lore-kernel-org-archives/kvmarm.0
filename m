Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0DC13ACC
	for <kvmarm@lists.linux.dev>; Mon, 26 Jun 2023 18:30:15 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6686c74183cso3375838b3a.1
        for <kvmarm@lists.linux.dev>; Mon, 26 Jun 2023 11:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687804215; x=1690396215;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QremIcf7iRsG9qDbVkiKuaPlPn4048SsLFTCD0Ysv2M=;
        b=GrCr0ShrComG94KO0A48krXyErRVG0IStcDfGl5TX8RiCg0R2CSQR1nisSrup1rf6z
         6dqupniRxWyPxn8qp0LRoPcI+WPmSmH96VeeN3UyBZdci+WpqRl607qepvkTnEGw9mk0
         DF5XiULqsAQWv5T3L4Ms8mRg6yjWnKsi+cWNkMe0ZkKoZVYsVN1FGgTWRiNErDoG1aNg
         b6O59sTfTNjxN9LVzftbLgo6ol5bTvj3XTjkO0ODfEIpUOZ+vecrLKXhY8kdmFjFVPdM
         6k00xP2W9nnPXc8iAEPpSlX/ycUeivi6ZvrnrDoP4TZHj/Rzj/kvlxU2EFDznAWtWACn
         Zz5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687804215; x=1690396215;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QremIcf7iRsG9qDbVkiKuaPlPn4048SsLFTCD0Ysv2M=;
        b=VerWWNBCDlFg0EIsBABTKeMS4nQjTw7L/ziO0kfhPATARVZIi8RYtD9UqClZUdf5eG
         oZ1qgfiLuL9RpYT8IqZMH3rZNaqZiz4vhGid922JnMkELpfLvjIoUNs9w/Ryc+LbB4Oq
         nJPW0f834zic89pTDHR597PcaGEtUZ6BFiZGQM03lHKo6GqWho4TKSOS8loIqpMtfwQH
         konoz84Fh4af6a5kieztcEnSQwmtcJt6l9A5Ysfh0E563KYjh3egQst0e/H+2Lxpv8wi
         dpKqnNFRmZQ5g4zKfJjLYnfQ0X/WGHuNTg5d52hFSd9aDQaHSyWpjefuKu6xinmk4WwN
         yXGQ==
X-Gm-Message-State: AC+VfDwDg7xcd7+sVARv5lbdo3WW5XqX66vdfM/xBtXlOAtGK7iAgkEp
	B5lvgzZN3ju2i4k6FCZGszg=
X-Google-Smtp-Source: ACHHUZ78LEkj8TNJrxfdIeuliRkkaDbVmg5Nv3baBTKc2IIiRiWXBDFe94AKZl3+69U9V87EyHAHEQ==
X-Received: by 2002:a05:6a20:3d89:b0:125:7c45:ad6 with SMTP id s9-20020a056a203d8900b001257c450ad6mr14877832pzi.15.1687804215111;
        Mon, 26 Jun 2023 11:30:15 -0700 (PDT)
Received: from smtpclient.apple ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id h3-20020a62b403000000b006468222af91sm4103121pfn.48.2023.06.26.11.30.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Jun 2023 11:30:14 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [kvm-unit-tests PATCH v2 1/6] efi: keep efi debug information in
 a separate file
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20230626-74deb6543bf4c51ef9b723f2@orel>
Date: Mon, 26 Jun 2023 11:30:03 -0700
Cc: kvmarm@lists.linux.dev,
 kvm@vger.kernel.org,
 Nikos Nikoleris <nikos.nikoleris@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Content-Transfer-Encoding: 7bit
Message-Id: <827839D1-F5F3-40FA-A57F-FC5DB22E2568@gmail.com>
References: <20230625230716.2922-1-namit@vmware.com>
 <20230625230716.2922-2-namit@vmware.com>
 <20230626-74deb6543bf4c51ef9b723f2@orel>
To: Andrew Jones <andrew.jones@linux.dev>
X-Mailer: Apple Mail (2.3731.600.7)



> On Jun 25, 2023, at 11:18 PM, Andrew Jones <andrew.jones@linux.dev> wrote:
> 
> !! External Email
> 
> On Sun, Jun 25, 2023 at 11:07:11PM +0000, Nadav Amit wrote:
>> From: Nadav Amit <namit@vmware.com>
>> 
>> Debugging tests that run on EFI is hard because the debug information is
>> not included in the EFI file. Dump it into a separeate .debug file to
>> allow the use of gdb or pretty_print_stacks script.
>> 
>> Signed-off-by: Nadav Amit <namit@vmware.com>
>> 
>> ---
>> 
>> v1->v2:
>> * Making clean should remove .debug [Andrew]
> 
> I forgot to point out in the previous review that not only do we need
> to clean but also add *.debug to .gitignore

I will do that for v3.

I did not (and still do not) understand what change you want for run_tests.sh
so I would indeed appreciate if you do this one.

