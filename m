Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE22E24E016
	for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 21:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760648839; cv=none; b=AG3YHsqdpFtwQaH1yertMli+sGpwX+oiCJM4ZcJ9J/36MY4difS8PcTIFhOSbg2DZbo1yLzytLjcEQg7CukoxoURa3adP155f7SVMlTyYCkO8pt9ahZFziuTBOsNe3AulmvB082QqRODlwJUzKiFHUIqqzwONmX7wmj0Eytj+d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760648839; c=relaxed/simple;
	bh=/PZwiIAPmraOr8DU5gpdQ0hm3ySju3FqvZeZeb5sXQM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q0oN6kl2uPBZeDlmquERwfCuqN6LGIQi7316d6wRZNz1mdLtQ7oHWydIy9/xdjnNSJvOZhEkbBXbHB6cbR//hEG7gfI5aHvsqKprRkQHX5U5jgxujyBag5qp+amXv46o1xGkGXuSt20LjkcAkTLe4QXz5+L5nE04q3FUMWzRs4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K1dYn6PC; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K1dYn6PC"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b67c74c7f20so142581a12.1
        for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 14:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760648837; x=1761253637; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YqKLtcHyZtQvUCKV9AK34ygiWjcxKsGF+96gmD+h6kc=;
        b=K1dYn6PCozj2Nc17Xvj0kRj/p4VY1F0ou6wCErNbgrk9dHk87etSR42WpsqKrx93HK
         y9PehaktDt2ZtBTVHnjJP4zhcUNBwBbxe3RkionUxwo0DgAGHOgsC98LFrq9NQEqC8/7
         rm0QRj1dpKSnV+t5i5Qb958/QWFA83KRaRVUAB4RyLunaRLJrsss1stvCEd+LBL2vFFs
         b2HNk5w99oyAiqEI7JPpQiXnPCtVZX++o/S/He1paT4vkNlh8yAmO//Z/FTC97GzYdzl
         ZRefTfNM5TKTZFEJToTNqepGweHZWxmAUx22AxZIa/AzSvjdJgPRueSe1KH5MSnZnrWk
         XYaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760648837; x=1761253637;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YqKLtcHyZtQvUCKV9AK34ygiWjcxKsGF+96gmD+h6kc=;
        b=P2wY7Ak164b/Ef3POpjN3Wc60xwAckM2Nf5emu5CZQKQ+Jpsu6FP9OvGkplXXvlwd7
         qREwI58v2ygy8odciGgAYtorGa+9vbBosXq+iQ8hXCQy73BPnOotVtYQhZnUYgOHSXPl
         szWWifmvVVUelRvUIsYijVv4tkTbiw9HHRMGM1J3l/oybaCCKTcCLhoC4si9q8ByRKTX
         haeBfU3oXlKG+E11oRzNbQM9wCF9MHQH9iSbT11pSZkzQz50o51XiBeWBPH5XLib6K22
         E4cpjfQUPPA5+ISd4dqSzLmQh5XyjiDblvs6PxneY/9SyQPI/8pWk1bcXTFQAyVuPs3r
         tm7w==
X-Forwarded-Encrypted: i=1; AJvYcCXDgUdTyslS5dbydmemjwUpwtkXBjZyhJ5qfiCTQH6G/fpoq5PC7FSuQyFfrgCAdpyOEoyrb9Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YwTyST8vvnv/cOrkPykQj/dS9JLO4gBbXufCdSqOnyCAnIPCEi/
	QEGOBROomxcWLjXB+u/xGpmQEodLMHoKlegfT5w7UPl8CoHFfKjON1eVZzwTaQr8ARv4Ye/AL+Q
	aNqVgOJoj2Qa6IzHItnrAb+U4u2t5hDU=
X-Gm-Gg: ASbGncswIkOFRpgR3GZ8+d17Ccz1tkzjtsZmAZDWnHfMbu9hxcJFpKn4/PZCrFhm2Iy
	Fxcypw++onoATfQRw9jP3f972WpCmC6YuA8JBwhbprBAPauf/9Yr7na9QNPQcpHdNZrRjeNnduy
	LxmmLBPCTju5xeqa8Y1gl+lFtYCU2RLDw4Bd2EpJ1oGqSlRZ63iq07YIp1TZLfGQWssKn6EFNGX
	VCyqGQ44F2qXMIKNE+MsJKZsCyzpuV0s8QaRfIkHbXhDczSnsxwoNBjli1aK9mL5BYZeTWpRCJt
	AZsARHjdZATXw3INRQBTmQpMw0QxjrWGxEkKHFfyJ1vZttbX97Eu7naZ5rve8o6EBP4S8Q/Ts+Z
	pUnPAHbqq5SkelNOl2ODpkCyx
X-Google-Smtp-Source: AGHT+IEIgAYtM+PkA8oLdH6dq6tTOHVM2SK/9pf6/KLEGFt0fs1UrG1QtsI18/3/wnm81TfvgNcSQoGgwMXacG4fjDo=
X-Received: by 2002:a17:903:40ca:b0:290:55ba:d70a with SMTP id
 d9443c01a7336-290c9cf3306mr8101005ad.2.1760648836981; Thu, 16 Oct 2025
 14:07:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com> <CANiq72ntKAeXRT_fEGJteUfuQuNUSjobmJCbQOuJWAcNFb1+9w@mail.gmail.com>
 <aPFVcMdfFlxhgGZh@google.com>
In-Reply-To: <aPFVcMdfFlxhgGZh@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 16 Oct 2025 23:07:02 +0200
X-Gm-Features: AS18NWCIqm_srauk6JXkuo1Nu5EkkFsJYyp4maKnlr0nVE8sbB1v3JnElr1TnCc
Message-ID: <CANiq72m6vWc9K+TLYoToGOWXXFB5tbAdf-crdx6U1UrBifEEBA@mail.gmail.com>
Subject: Re: [PATCH v13 00/12] KVM: guest_memfd: Add NUMA mempolicy support
To: Sean Christopherson <seanjc@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 16, 2025 at 10:28=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> Oh, I take it .clang-format is auto-generated?  Is it a "formal" script, =
or do
> you literally just run the grep command in the comment?

I just run it and copy-paste the results there from time to time.
Yeah, a very low-tech solution :)

> I don't think I care if it's in the list?  I honestly don't know for sure=
, because
> it's entirely possible I'm consuming .clang-format without knowing it.  I=
 added
> the entry based on someone else's request.
>
> Ackerley?

If you are not relying on it, then please just skip it, yeah.

> Is it possible, and sensible, to have per-subsystem .clang-format files? =
 KVM
> (virt/kvm) and KVM x86 (arch/x86/kvm) both have has several for_each macr=
os,
> pretty much all of which are more interesting than kvm_gmem_for_each_file=
().

There is `InheritParentConfig` nowadays, but from a quick look I don't
see it supports merging lists.

So to do something fancier, we would do need something like we did for
rust-analyzer, i.e. a `make` target or similar that would generate it.

Otherwise, we can just add extra macros at the top meanwhile.

What we did last time is just to add `tools/` to that command --
increasing coverage is not an issue (I just started with `include/`
originally to be a bit conservative and avoid a huge list until we
knew the tool would be used).

Cheers,
Miguel
