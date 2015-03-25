From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: ARM: KVM/XEN: how should we support virt-what?
Date: Wed, 25 Mar 2015 11:56:08 +0100
Message-ID: <55129448.6000200@redhat.com>
References: <20150325094440.GB3163@hawk.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150325094440.GB3163@hawk.usersys.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, christoffer.dall@linaro.org, marc.zyngier@arm.com, Ian.Campbell@citrix.com, stefano.stabellini@eu.citrix.com, tim@xen.org
Cc: kvm@vger.kernel.org, xen-devel@lists.xen.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 25/03/2015 10:44, Andrew Jones wrote:
> 2) create a specific DT node that will get exposed through sysfs, or
>    somewhere.

Looking at custom DT nodes is what PowerPC does.

Paolo
